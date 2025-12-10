import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/database/cache_helper.dart';
import '../../../../core/helper/database/cache_helper_keks.dart';
import '../../../../core/theme/theme_cubit.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final CacheHelper _cacheHelper;
  final ThemeCubit _themeCubit;

  SettingsCubit({CacheHelper? cacheHelper, required ThemeCubit themeCubit})
    : _cacheHelper = cacheHelper ?? CacheHelper(),
      _themeCubit = themeCubit,
      super(const SettingsState()) {
    loadSettings();
  }

  /// Load all settings from cache
  Future<void> loadSettings() async {
    try {
      emit(state.copyWith(isLoading: true));

      // Load profile image
      final imageProfilePath = _cacheHelper.getData(
        key: CacheHelperKeys.imageProfile,
      );
      File? imageFile;
      if (imageProfilePath != null && imageProfilePath is String) {
        imageFile = File(imageProfilePath);
      }

      // Load other settings
      final username = _cacheHelper.getData(key: CacheHelperKeys.username);
      final currency = _cacheHelper.getData(key: CacheHelperKeys.currency);
      final language = _cacheHelper.getData(key: CacheHelperKeys.language);
      final theme = _cacheHelper.getData(key: CacheHelperKeys.theme) ?? 'light';
      final reminderEnabled =
          _cacheHelper.getData(key: CacheHelperKeys.reminderEnabled) ?? false;

      final appLockEnabled =
          _cacheHelper.getData(key: CacheHelperKeys.appLockEnabled) ?? false;
      final appLockPin = _cacheHelper.getData(key: CacheHelperKeys.appLockPin);

      final savedHour = _cacheHelper.getData(key: CacheHelperKeys.reminderHour);
      final savedMinute = _cacheHelper.getData(
        key: CacheHelperKeys.reminderMinute,
      );
      TimeOfDay reminderTime = const TimeOfDay(hour: 10, minute: 0);
      if (savedHour != null && savedMinute != null) {
        reminderTime = TimeOfDay(hour: savedHour, minute: savedMinute);
      }

      emit(
        SettingsState(
          imageFile: imageFile,
          username: username,
          currency: currency,
          language: language,
          theme: theme,
          reminderEnabled: reminderEnabled,
          reminderTime: reminderTime,
          appLockEnabled: appLockEnabled,
          appLockPin: appLockPin is String ? appLockPin : null,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load settings: $e',
        ),
      );
    }
  }

  /// Toggle theme (light, dark, system)
  Future<void> toggleTheme(String themeCode) async {
    try {
      await _themeCubit.setTheme(themeCode);
      emit(state.copyWith(theme: themeCode));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to change theme: $e'));
    }
  }

  /// Change language
  Future<void> changeLanguage(String languageCode) async {
    try {
      await _cacheHelper.saveData(
        key: CacheHelperKeys.language,
        value: languageCode,
      );
      emit(state.copyWith(language: languageCode));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to change language: $e'));
    }
  }

  /// Change currency
  Future<void> changeCurrency(String currencyCode) async {
    try {
      await _cacheHelper.saveData(
        key: CacheHelperKeys.currency,
        value: currencyCode,
      );
      emit(state.copyWith(currency: currencyCode));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to change currency: $e'));
    }
  }

  /// Toggle reminder on/off
  Future<void> toggleReminder(bool enabled) async {
    try {
      await _cacheHelper.saveData(
        key: CacheHelperKeys.reminderEnabled,
        value: enabled,
      );
      emit(state.copyWith(reminderEnabled: enabled));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to toggle reminder: $e'));
    }
  }

  /// Set reminder time
  Future<void> setReminderTime(TimeOfDay time) async {
    try {
      await _cacheHelper.saveData(
        key: CacheHelperKeys.reminderHour,
        value: time.hour,
      );
      await _cacheHelper.saveData(
        key: CacheHelperKeys.reminderMinute,
        value: time.minute,
      );
      emit(state.copyWith(reminderTime: time));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to set reminder time: $e'));
    }
  }

  /// Update username
  Future<void> updateUsername(String username) async {
    try {
      await _cacheHelper.saveData(
        key: CacheHelperKeys.username,
        value: username,
      );
      emit(state.copyWith(username: username));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update username: $e'));
    }
  }

  /// Update profile image
  Future<void> updateProfileImage(File imageFile) async {
    try {
      await _cacheHelper.saveData(
        key: CacheHelperKeys.imageProfile,
        value: imageFile.path,
      );
      emit(state.copyWith(imageFile: imageFile));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update profile image: $e'));
    }
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  /// Toggle app lock enabled/disabled and optionally set a PIN
  Future<void> setAppLock({required bool enabled, String? pin}) async {
    try {
      await _cacheHelper.saveData(
        key: CacheHelperKeys.appLockEnabled,
        value: enabled,
      );
      if (pin != null) {
        await _cacheHelper.saveData(
          key: CacheHelperKeys.appLockPin,
          value: pin,
        );
      }
      emit(
        state.copyWith(
          appLockEnabled: enabled,
          appLockPin: pin ?? state.appLockPin,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update app lock: $e'));
    }
  }

  /// Update only the PIN without toggling enable flag
  Future<void> updateAppLockPin(String pin) async {
    try {
      await _cacheHelper.saveData(key: CacheHelperKeys.appLockPin, value: pin);
      emit(state.copyWith(appLockPin: pin));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update PIN: $e'));
    }
  }
}
