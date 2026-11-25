import 'package:flutter/material.dart';

class AppColors {
  static const Color lightest = Color(0xFFE3F2FD); // Blue 50
  static const Color light = Color(0xFF90CAF9);    // Blue 200
  static const Color primary = Color(0xFF2196F3);  // Blue 500
  static const Color darkest = Color(0xFF0D47A1);  // Blue 900
  static const Color white = Colors.white;
  static const Color cardBg = Colors.white;
  static const Color textSecondary = Color(0xFF546E7A);
  static const Color error = Color(0xFFD32F2F);
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.lightest,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.light,
    onPrimaryContainer: AppColors.darkest,
    secondary: AppColors.light,
    onSecondary: AppColors.darkest,
    tertiary: AppColors.darkest,
    surface: AppColors.lightest,
    onSurface: AppColors.darkest,
    error: AppColors.error,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkest,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardThemeData(
    color: AppColors.cardBg,
    elevation: 2,
    shadowColor: AppColors.darkest.withAlpha(25),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
    prefixIconColor: AppColors.primary,
    suffixIconColor: AppColors.primary,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.light.withAlpha(128)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.light.withAlpha(128)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 64, fontWeight: FontWeight.w300, color: AppColors.darkest),
    displayMedium: TextStyle(fontSize: 48, fontWeight: FontWeight.w400, color: AppColors.darkest),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.darkest),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkest),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.darkest),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkest),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.darkest),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkest),
    bodySmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
  ),
);
