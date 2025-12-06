import 'package:flutter/material.dart';

/// Extension to help with theme-aware colors
extension ThemeExtension on BuildContext {
  /// Returns true if the current theme is dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Returns the appropriate color based on the current theme
  Color themeColor({required Color light, required Color dark}) {
    return isDarkMode ? dark : light;
  }

  /// Surface color that adapts to theme
  Color get surfaceColor => Theme.of(this).colorScheme.surface;

  /// Background color that adapts to theme
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;

  /// Primary color
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  /// Text color that adapts to theme
  Color get textColor => Theme.of(this).colorScheme.onSurface;

  /// Secondary text color
  Color get secondaryTextColor =>
      isDarkMode ? const Color(0xFFCCCCCC) : const Color(0xFF6B7580);

  /// Divider color
  Color get dividerColor => Theme.of(this).dividerColor;

  /// Card color
  Color get cardColor => Theme.of(this).cardTheme.color ?? surfaceColor;
}
