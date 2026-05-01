import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lbef/model/user_model.dart';
import 'package:lbef/screen/auth/login_page.dart';
import 'package:lbef/screen/navbar/student_navbar.dart';
import 'package:lbef/services/biometric_service.dart';
import 'package:lbef/view_model/user_view_model/user_view_model.dart';
import 'package:lbef/widgets/no_internet_wrapper.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import '../../data/api_response.dart';
import '../../data/status.dart';
import '../../repository/authentication_repo/auth_repository.dart';
import '../../utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _myrepo = AuthRepository();
  final Logger logger = Logger();

  ApiResponse<UserModel> userData = ApiResponse.loading();
  UserModel? get currentUser => userData.data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _role = '';
  String get role => _role;

  // Holds the regular login token so biometric setup can use it after login
  String? _regularToken;
  String? get token => _regularToken;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUser(ApiResponse<UserModel> response) {
    userData = response;
    notifyListeners();
  }

  // ── Normal password login ─────────────────────────────────────────────────

  Future<void> login(dynamic body, BuildContext context) async {
    setLoading(true);
    try {
      final response = await _myrepo.login(body, context: context);
      if (response.status == Status.ERROR) {
        setUser(ApiResponse.error(response.message ?? "Unexpected error"));
        Utils.flushBarErrorMessage(
            response.message ?? "Unexpected error", context);
        return;
      }

      setUser(ApiResponse.completed(response.data));

      // Cache token so setupBiometric() can use it immediately after login
      // Adjust 'token' to match your actual UserModel field name
      _regularToken = response.data?.token;
      notifyListeners();

      Utils.flushBarSuccessMessage(
          response.message ?? "User Logged in successfully!", context);
      _navigateToHome(context);
    } catch (error) {
      setUser(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
    } finally {
      setLoading(false);
    }
  }

  // ── Biometric setup (called after password login) ─────────────────────────

  /// Calls GET /api/biometrics with the cached regular token.
  /// On success, saves the returned biometric token securely.
  /// Returns true on success, false on any failure.
  Future<bool> setupBiometric(BuildContext context) async {
    setLoading(true);
    try {
      final biometricToken = await _myrepo.fetchBiometricToken();
      if (biometricToken == null) {
        Utils.flushBarErrorMessage(
            'Could not enable biometrics. Please try again.', context);
        return false;
      }
      await BiometricService.saveToken(biometricToken);
      logger.d('Biometric token saved successfully.');
      return true;
    } catch (e) {
      logger.e('setupBiometric error: $e');
      Utils.flushBarErrorMessage(
          'Error enabling biometrics: ${e.toString()}', context);
      return false;
    } finally {
      setLoading(false);
    }
  }

  // ── Biometric login flow ──────────────────────────────────────────────────

  /// Full biometric login:
  /// Step 1 — Trigger OS fingerprint/face prompt via BiometricService
  /// Step 2 — On success, retrieve the saved biometric token
  /// Step 3 — POST to /api/biometrics with that token
  /// Step 4 — Parse the response, save session, navigate home
  ///
  /// Returns true on full success, false on any failure.
  /// Shows appropriate error messages for each failure case.
  Future<bool> loginWithBiometric(BuildContext context) async {
    // Do NOT call setLoading here — the login page manages its own
    // isLoading spinner. setLoading would cause a ChangeNotifier rebuild
    // mid-auth which can interfere with the OS biometric dialog.
    try {
      // Step 1: Trigger local biometric authentication
      // BiometricService.authenticate() never throws — returns false on any failure
      final authenticated = await BiometricService.authenticate();
      if (!authenticated) {
        // User cancelled, failed, or hardware issue — don't show error here
        // because the OS already shows its own UI for failures.
        // Just return false silently; login page decides what to show.
        logger.w('Biometric auth returned false (cancelled or failed).');
        return false;
      }

      // Step 2: Get the stored biometric token
      final biometricToken = await BiometricService.getToken();
      if (biometricToken == null) {
        logger.w('No biometric token found in storage.');
        Utils.flushBarErrorMessage(
            'Biometric not configured. Please log in with your password.',
            context);
        return false;
      }

      // Step 3: Validate token with server
      logger.d('Sending biometric token to server...');
      final responseData =
      await _myrepo.loginWithBiometricToken(biometricToken);
      if (responseData == null) {
        logger.w('Server rejected biometric token.');
        Utils.flushBarErrorMessage(
            'Biometric login failed. Please use your password.', context);
        // Clear the bad token so the user isn't stuck
        // await BiometricService.clearToken();
        return false;
      }

      // Step 4: Parse user, save session, navigate
      logger.d('Biometric login response: $responseData');
      final user = UserModel.fromJson(responseData);

      // Save user to local storage (same as normal login)
      await UserViewModel().saveUser(user);

      setUser(ApiResponse.completed(user));
      // Adjust 'token' field to match your UserModel
      _regularToken = user.token;
      notifyListeners();

      Utils.flushBarSuccessMessage('Logged in successfully!', context);
      _navigateToHome(context);
      return true;
    } on PlatformException catch (e) {
      // Catch any PlatformException that slipped through BiometricService
      logger.e('PlatformException in loginWithBiometric: ${e.code} — ${e.message}');
      // Map known error codes to friendly messages
      String message;
      switch (e.code) {
        case 'NotEnrolled':
        case 'notEnrolled':
          message = 'No fingerprints enrolled on this device.';
          break;
        case 'LockedOut':
        case 'lockedOut':
          message = 'Too many attempts. Try again later.';
          break;
        case 'PermanentlyLockedOut':
        case 'permanentlyLockedOut':
          message = 'Biometrics locked. Unlock with your device PIN first.';
          break;
        default:
          message = 'Biometric error. Please use your password.';
      }
      Utils.flushBarErrorMessage(message, context);
      return false;
    } catch (e) {
      logger.e('loginWithBiometric unexpected error: $e');
      Utils.flushBarErrorMessage(
          'An unexpected error occurred. Please use your password.', context);
      return false;
    }
  }

  // ── Other methods ─────────────────────────────────────────────────────────

  Future<bool> recover(BuildContext context, dynamic body) async {
    setLoading(true);
    final _logger = Logger();
    try {
      final check = await _myrepo.recover(context, body);
      return check;
    } catch (e) {
      _logger.e('recover error: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    setLoading(true);
    try {
      final response = await _myrepo.logout();
      if (response.status == Status.COMPLETED) {
        Utils.flushBarSuccessMessage(
            response.message ?? "User Logged out Successfully!", context);
        _regularToken = null;
        await UserViewModel().remove(context);
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              final tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));
              return SlideTransition(
                  position: animation.drive(tween), child: child);
            },
          ),
              (route) => false,
        );
      } else {
        Utils.flushBarErrorMessage(
            response.message ?? "An error occurred", context);
      }
    } catch (error) {
      logger.e("Logout Error", error: error);
      Utils.flushBarErrorMessage(error.toString(), context);
    } finally {
      setLoading(false);
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        const NoInternetWrapper(child: StudentNavbar()),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
              position: animation.drive(tween), child: child);
        },
      ),
          (route) => false,
    );
  }
}