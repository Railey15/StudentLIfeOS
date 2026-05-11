import 'package:flutter/material.dart';

class AppPalette {
  static const canvas = Color(0xFFF4F7FB);
  static const navy = Color(0xFF123C73);
  static const royalBlue = Color(0xFF2563EB);
  static const brightRed = Color(0xFFD72638);
  static const sky = Color(0xFFDCEBFF);
  static const softRed = Color(0xFFFFE0E4);
  static const softGreen = Color(0xFFE7F8EE);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const card = Colors.white;
  static const deepNav = Color(0xFF0B1730);
}

ThemeData buildStudentLifeTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppPalette.royalBlue,
    brightness: Brightness.light,
    primary: AppPalette.navy,
    secondary: AppPalette.brightRed,
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppPalette.canvas,
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppPalette.ink,
          displayColor: AppPalette.ink,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: AppPalette.ink,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppPalette.sky,
      selectedColor: AppPalette.royalBlue,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        color: AppPalette.navy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppPalette.navy.withValues(alpha: 0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppPalette.royalBlue, width: 1.4),
      ),
    ),
  );
}
