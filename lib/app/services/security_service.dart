import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SecurityService extends GetxService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Storage keys
  static const String _pinHashKey = 'pin_hash';
  static const String _lockEnabledKey = 'lock_enabled';
  static const String _lockTypeKey = 'lock_type';
  static const String _autoLockTimerKey = 'auto_lock_timer';
  static const String _privacyModeKey = 'privacy_mode';

  final isAppLocked = false.obs;
  final isLockEnabled = false.obs;
  final lockType = LockType.pin.obs;
  final autoLockTimer = AutoLockTimer.oneMinute.obs;
  final isPrivacyMode = false.obs;

  DateTime? _lastBackgroundTime;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  /// Load security settings
  Future<void> loadSettings() async {
    final lockEnabled = await _secureStorage.read(key: _lockEnabledKey);
    isLockEnabled.value = lockEnabled == 'true';

    final lockTypeStr = await _secureStorage.read(key: _lockTypeKey);
    if (lockTypeStr != null) {
      lockType.value = LockType.values.firstWhere(
        (e) => e.toString() == lockTypeStr,
        orElse: () => LockType.pin,
      );
    }

    final timerStr = await _secureStorage.read(key: _autoLockTimerKey);
    if (timerStr != null) {
      autoLockTimer.value = AutoLockTimer.values.firstWhere(
        (e) => e.toString() == timerStr,
        orElse: () => AutoLockTimer.oneMinute,
      );
    }

    final privacyMode = await _secureStorage.read(key: _privacyModeKey);
    isPrivacyMode.value = privacyMode == 'true';
  }

  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometric() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access ExpenseWise',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  /// Set PIN
  Future<void> setPin(String pin) async {
    final hash = _hashPin(pin);
    await _secureStorage.write(key: _pinHashKey, value: hash);
  }

  /// Verify PIN
  Future<bool> verifyPin(String pin) async {
    final storedHash = await _secureStorage.read(key: _pinHashKey);
    if (storedHash == null) return false;

    final inputHash = _hashPin(pin);
    return storedHash == inputHash;
  }

  /// Check if PIN is set
  Future<bool> isPinSet() async {
    final hash = await _secureStorage.read(key: _pinHashKey);
    return hash != null;
  }

  /// Hash PIN using SHA-256
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Enable app lock
  Future<void> enableLock(LockType type) async {
    await _secureStorage.write(key: _lockEnabledKey, value: 'true');
    await _secureStorage.write(key: _lockTypeKey, value: type.toString());
    isLockEnabled.value = true;
    lockType.value = type;
  }

  /// Disable app lock
  Future<void> disableLock() async {
    await _secureStorage.write(key: _lockEnabledKey, value: 'false');
    isLockEnabled.value = false;
    isAppLocked.value = false;
  }

  /// Set auto-lock timer
  Future<void> setAutoLockTimer(AutoLockTimer timer) async {
    await _secureStorage.write(key: _autoLockTimerKey, value: timer.toString());
    autoLockTimer.value = timer;
  }

  /// Toggle privacy mode
  Future<void> togglePrivacyMode(bool enabled) async {
    await _secureStorage.write(key: _privacyModeKey, value: enabled.toString());
    isPrivacyMode.value = enabled;
  }

  /// Lock the app
  void lockApp() {
    if (isLockEnabled.value) {
      isAppLocked.value = true;
    }
  }

  /// Unlock the app
  void unlockApp() {
    isAppLocked.value = false;
  }

  /// Handle app going to background
  void onAppPaused() {
    _lastBackgroundTime = DateTime.now();
  }

  /// Handle app resuming from background
  void onAppResumed() {
    if (!isLockEnabled.value) return;
    if (_lastBackgroundTime == null) return;

    final elapsed = DateTime.now().difference(_lastBackgroundTime!);
    final shouldLock = _shouldLockAfterDuration(elapsed);

    if (shouldLock) {
      lockApp();
    }
  }

  /// Check if app should lock based on elapsed time
  bool _shouldLockAfterDuration(Duration elapsed) {
    switch (autoLockTimer.value) {
      case AutoLockTimer.immediate:
        return true;
      case AutoLockTimer.oneMinute:
        return elapsed.inMinutes >= 1;
      case AutoLockTimer.fiveMinutes:
        return elapsed.inMinutes >= 5;
      case AutoLockTimer.fifteenMinutes:
        return elapsed.inMinutes >= 15;
      case AutoLockTimer.never:
        return false;
    }
  }

  /// Reset all security settings
  Future<void> resetSecurity() async {
    await _secureStorage.delete(key: _pinHashKey);
    await _secureStorage.delete(key: _lockEnabledKey);
    await _secureStorage.delete(key: _lockTypeKey);
    await _secureStorage.delete(key: _autoLockTimerKey);
    await _secureStorage.delete(key: _privacyModeKey);

    isLockEnabled.value = false;
    isAppLocked.value = false;
    lockType.value = LockType.pin;
    autoLockTimer.value = AutoLockTimer.oneMinute;
    isPrivacyMode.value = false;
  }
}

enum LockType { pin, biometric, both }

extension LockTypeExtension on LockType {
  String get displayName {
    switch (this) {
      case LockType.pin:
        return 'PIN';
      case LockType.biometric:
        return 'Biometric';
      case LockType.both:
        return 'PIN & Biometric';
    }
  }
}

enum AutoLockTimer { immediate, oneMinute, fiveMinutes, fifteenMinutes, never }

extension AutoLockTimerExtension on AutoLockTimer {
  String get displayName {
    switch (this) {
      case AutoLockTimer.immediate:
        return 'Immediate';
      case AutoLockTimer.oneMinute:
        return '1 Minute';
      case AutoLockTimer.fiveMinutes:
        return '5 Minutes';
      case AutoLockTimer.fifteenMinutes:
        return '15 Minutes';
      case AutoLockTimer.never:
        return 'Never';
    }
  }
}
