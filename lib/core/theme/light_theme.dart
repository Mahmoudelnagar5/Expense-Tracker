import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Primary color scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryBrand,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondaryGreenLight,
        secondaryContainer: AppColors.secondaryBlueLight,
        surface: AppColors.neutralWhite,
        surfaceContainerHighest: AppColors.neutralSoftGrey2,
        error: AppColors.systemRed,
        onPrimary: Colors.white,
        onSecondary: AppColors.neutralDark1,
        onSurface: AppColors.neutralDark1,
        onError: Colors.white,
        outline: AppColors.neutralGrey3,
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.neutralSoftGrey3,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.neutralSoftGrey3,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card theme
      cardTheme: const CardThemeData(
        color: AppColors.neutralWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBrand,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryBrand),
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: AppColors.neutralDark1),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColors.neutralGrey3,
        thickness: 1,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutralSoftGrey2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBrand, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.systemRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.neutralWhite,
        selectedItemColor: const Color(0xFF00BCD4),
        unselectedItemColor: AppColors.neutralGrey2,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog theme
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.neutralWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryBrand,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryBrand;
          }
          return AppColors.neutralGrey2;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight.withOpacity(0.5);
          }
          return AppColors.neutralGrey3;
        }),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryBrand;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryBrand;
          }
          return AppColors.neutralGrey2;
        }),
      ),
    );
  }
}
