import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Helper class for localization utilities
class LocalizationHelper {
  /// Get current locale
  static Locale getCurrentLocale(BuildContext context) {
    return context.locale;
  }

  /// Check if current locale is Arabic
  static bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  /// Check if current locale is English
  static bool isEnglish(BuildContext context) {
    return context.locale.languageCode == 'en';
  }

  /// Switch to Arabic
  static Future<void> switchToArabic(BuildContext context) async {
    await context.setLocale(const Locale('ar'));
  }

  /// Switch to English
  static Future<void> switchToEnglish(BuildContext context) async {
    await context.setLocale(const Locale('en'));
  }

  /// Switch language
  static Future<void> switchLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    await context.setLocale(Locale(languageCode));
  }

  /// Get supported locales
  static List<Locale> get supportedLocales => const [
    Locale('ar'),
    Locale('en'),
  ];

  /// Get language name by code
  static String getLanguageName(String code) {
    switch (code) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return code;
    }
  }
}
