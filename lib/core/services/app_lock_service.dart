import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import '../helper/database/cache_helper.dart';
import '../helper/database/cache_helper_keks.dart';
import '../utils/locale_keys.dart';

/// Service to manage app lock functionality
class AppLockService {
  static final AppLockService _instance = AppLockService._internal();
  factory AppLockService() => _instance;
  AppLockService._internal();

  final CacheHelper _cacheHelper = CacheHelper();
  bool _isShowingLockScreen = false;

  /// Reset the lock screen state (call when app starts fresh)
  void reset() {
    _isShowingLockScreen = false;
  }

  /// Check if app lock is enabled
  bool get isAppLockEnabled =>
      _cacheHelper.getData(key: CacheHelperKeys.appLockEnabled) ?? false;

  /// Get the stored PIN
  String? get storedPin =>
      _cacheHelper.getData(key: CacheHelperKeys.appLockPin);

  /// Check if app should be locked
  bool get shouldLock => isAppLockEnabled && storedPin != null;

  /// Check if lock screen is currently showing
  bool get isShowingLockScreen => _isShowingLockScreen;

  /// Show lock screen
  Future<bool> showLockScreen(BuildContext context) async {
    if (!shouldLock || _isShowingLockScreen) return true;

    final pin = storedPin;
    if (pin == null) return true;

    _isShowingLockScreen = true;
    bool unlocked = false;

    await screenLock(
      context: context,
      title: Text(
        LocaleKeys.enterCurrentPin.tr(),
        style: const TextStyle(color: Colors.white),
      ),
      correctString: pin,
      canCancel: false,
      onUnlocked: () {
        unlocked = true;
        Navigator.of(context).pop();
      },
      config: const ScreenLockConfig(backgroundColor: Colors.black87),
      deleteButton: const Icon(Icons.backspace, color: Colors.white),
      keyPadConfig: KeyPadConfig(
        buttonConfig: KeyPadButtonConfig(
          fontSize: 24,
          foregroundColor: Colors.white,
        ),
      ),
      secretsConfig: SecretsConfig(
        secretConfig: SecretConfig(
          enabledColor: Colors.white,
          disabledColor: Colors.white38,
        ),
      ),
    );

    _isShowingLockScreen = false;
    return unlocked;
  }
}
