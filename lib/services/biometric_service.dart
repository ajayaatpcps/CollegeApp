import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();
  static const _storage = FlutterSecureStorage(
    // Android options — encrypts the storage
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  static const _tokenKey = 'biometric_token';
  static final _logger = Logger();

  /// Returns true only if:
  /// • the device hardware supports biometrics, AND
  /// • the user has enrolled at least one biometric (fingerprint/face)
  ///
  /// This prevents the fingerprint button from showing on devices
  /// where biometrics are supported in hardware but no finger is enrolled.
  static Future<bool> isAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      if (!canCheck || !isSupported) return false;

      // Also check that at least one biometric is enrolled
      final enrolled = await _auth.getAvailableBiometrics();
      _logger.d('Available biometrics: $enrolled');
      return enrolled.isNotEmpty;
    } catch (e) {
      _logger.e('isAvailable error: $e');
      return false;
    }
  }

  /// Returns true if a biometric token has been saved (i.e., setup is complete).
  static Future<bool> isSetup() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      _logger.e('isSetup error: $e');
      return false;
    }
  }

  /// Triggers the OS biometric prompt.
  /// Returns true if the user successfully authenticates.
  /// Returns false (never throws) for any failure or cancellation.
  static Future<bool> authenticate() async {
    try {
      _logger.d('Starting biometric authentication...');
      final result = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to log in',
        options: const AuthenticationOptions(
          // biometricOnly: true means PIN/pattern fallback is NOT offered.
          // Set to false if you want to allow device PIN as fallback.
          biometricOnly: false,
          stickyAuth: true,   // keeps prompt alive if user switches apps
          sensitiveTransaction: false,
        ),
      );
      _logger.d('Authentication result: $result');
      return result;
    } on PlatformException catch (e) {
      // Common error codes:
      // notAvailable       — biometrics not set up on device
      // notEnrolled        — no fingerprints enrolled
      // lockedOut          — too many failed attempts
      // permanentlyLockedOut — requires PIN unlock to reset
      // passcodeNotSet     — device has no screen lock
      _logger.e('PlatformException during auth: ${e.code} — ${e.message}');
      return false;
    } catch (e) {
      _logger.e('Unexpected auth error: $e');
      return false;
    }
  }

  /// Saves the biometric token securely on device.
  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      _logger.d('Biometric token saved.');
    } catch (e) {
      _logger.e('saveToken error: $e');
    }
  }

  /// Retrieves the saved biometric token. Returns null if not set.
  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      _logger.e('getToken error: $e');
      return null;
    }
  }

  /// Deletes the saved biometric token (disables biometric login).
  static Future<void> clearToken() async {
    try {
      await _storage.delete(key: _tokenKey);
      _logger.d('Biometric token cleared.');
    } catch (e) {
      _logger.e('clearToken error: $e');
    }
  }
}