import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Primary color scheme - matching the blue accent in the screenshot
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryBrand,
        primaryContainer: const Color(0xFF2952CC),
        secondary: const Color(0xFF5B9FED), // Light blue accents
        secondaryContainer: const Color(0xFF1E3A5F),
        surface: const Color(0xFF1C2834), // Card/surface color from screenshot
        surfaceContainerHighest: const Color(0xFF253342),
        error: AppColors.systemRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFFE8EAF0), // Light text
        onError: Colors.white,
        outline: const Color(0xFF3A4756),
      ),

      // Scaffold background - darker navy blue from screenshot
      scaffoldBackgroundColor: const Color(0xFF0D1B2A),

      // AppBar theme
      appBarTheme: const AppBarThemeData(
        backgroundColor: Color(0xFF1C2834),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card theme - matching the card color from screenshot
      cardTheme: const CardThemeData(
        color: Color(0xFF1C2834),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4169E1), // Royal blue
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: const Color(0xFF5B9FED)),
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: Color(0xFFB8C5D6)),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A3947),
        thickness: 1,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF253342),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF4169E1), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.systemRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1C2834),
        selectedItemColor: Color(0xFF4169E1),
        unselectedItemColor: Color(0xFF6B7A8F),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // Dialog theme
      dialogTheme: const DialogThemeData(
        backgroundColor: Color(0xFF1C2834),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF4169E1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF4169E1),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF4169E1);
          }
          return const Color(0xFF6B7A8F);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF4169E1).withOpacity(0.5);
          }
          return const Color(0xFF3A4756);
        }),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF4169E1);
          }
          return const Color(0xFF6B7A8F);
        }),
      ),

      // Text theme (for dark mode readability)
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFE8EAF0)),
        bodyMedium: TextStyle(color: Color(0xFFE8EAF0)),
        bodySmall: TextStyle(color: Color(0xFFB8C5D6)),
        titleLarge: TextStyle(color: Color(0xFFF5F6FA)),
        titleMedium: TextStyle(color: Color(0xFFF5F6FA)),
        titleSmall: TextStyle(color: Color(0xFFE8EAF0)),
      ),
    );
  }
}
