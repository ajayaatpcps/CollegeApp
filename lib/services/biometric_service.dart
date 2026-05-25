import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
    } on PlatformException catch (e, stack) {
      // Common error codes:
      // notAvailable       — biometrics not set up on device
      // notEnrolled        — no fingerprints enrolled
      // lockedOut          — too many failed attempts
      // permanentlyLockedOut — requires PIN unlock to reset
      // passcodeNotSet     — device has no screen lock
      //
      // Do NOT swallow this. In release builds `logger` output is invisible,
      // which is why biometric login failed silently on the Play Store build.
      // Record the real cause to Crashlytics, then rethrow so the caller can
      // show a specific message instead of "nothing happens".
      _logger.e('PlatformException during auth: ${e.code} — ${e.message}');
      await FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'BiometricService.authenticate failed (${e.code})',
        information: ['code: ${e.code}', 'message: ${e.message}'],
        fatal: false,
      );
      rethrow;
    } catch (e, stack) {
      _logger.e('Unexpected auth error: $e');
      await FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'BiometricService.authenticate unexpected error',
        fatal: false,
      );
      rethrow;
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