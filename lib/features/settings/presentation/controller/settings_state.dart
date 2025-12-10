import 'dart:io';
import 'package:flutter/material.dart';

class SettingsState {
  final File? imageFile;
  final String? username;
  final String? currency;
  final String? language;
  final String? theme;
  final bool reminderEnabled;
  final TimeOfDay reminderTime;
  final bool appLockEnabled;
  final String? appLockPin;
  final bool isLoading;
  final String? errorMessage;

  const SettingsState({
    this.imageFile,
    this.username,
    this.currency,
    this.language,
    this.theme,
    this.reminderEnabled = false,
    this.reminderTime = const TimeOfDay(hour: 10, minute: 0),
    this.appLockEnabled = false,
    this.appLockPin,
    this.isLoading = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    File? imageFile,
    String? username,
    String? currency,
    String? language,
    String? theme,
    bool? reminderEnabled,
    TimeOfDay? reminderTime,
    bool? appLockEnabled,
    String? appLockPin,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SettingsState(
      imageFile: imageFile ?? this.imageFile,
      username: username ?? this.username,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      appLockPin: appLockPin ?? this.appLockPin,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
