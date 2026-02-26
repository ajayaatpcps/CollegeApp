import 'package:flutter/cupertino.dart';
import 'package:lbef/model/user_model.dart';
import 'package:lbef/screen/auth/login_page.dart';
import 'package:lbef/screen/navbar/student_navbar.dart';
import 'package:lbef/view_model/user_view_model/user_view_model.dart';
import 'package:lbef/widgets/no_internet_wrapper.dart';
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

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUser(ApiResponse<UserModel> response) {
    userData = response;
    notifyListeners();
  }

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
      Utils.flushBarSuccessMessage(
          response.message ?? "User Logged in successfully!", context);
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const NoInternetWrapper(child: StudentNavbar()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
        (route) => false, // Remove all previous routes
      );
    } catch (error) {
      setUser(ApiResponse.error(error.toString()));
      Utils.flushBarErrorMessage(error.toString(), context);
    } finally {
      setLoading(false);
    }
  }

  Future<bool> recover(BuildContext context, dynamic body) async {
    setLoading(true);
    var _logger = Logger();
    try {
      bool? check = await _myrepo.recover(context, body);
      if (check) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _logger.e('getUser error: $e');
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
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
          (route) => false, // Remove all previous routes
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
}
