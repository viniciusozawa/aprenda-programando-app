import 'package:flutter/material.dart';

// ── NEON ARCADE PALETTE ──────────────────────────────────
class AppColors {
  static const Color bg        = Color(0xFF0C0A14);
  static const Color surface   = Color(0xFF1C1830);
  static const Color surface2  = Color(0xFF262040);
  static const Color red       = Color(0xFFE11D48);
  static const Color orange    = Color(0xFFF97316);
  static const Color yellow    = Color(0xFFFACC15);
  static const Color green     = Color(0xFF34D399);
  static const Color indigo    = Color(0xFF818CF8);
  static const Color purple    = Color(0xFFA855F7);
  static const Color white     = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFB3AED1);
  static const Color textSub   = Color(0xFF817D9E);

  // Dark tints para chips de comando
  static const Color redDark    = Color(0xFF4F0C19);
  static const Color orangeDark = Color(0xFF4E2307);
  static const Color greenDark  = Color(0xFF104228);
  static const Color indigoDark = Color(0xFF121038);
  static const Color purpleDark = Color(0xFF2E0F50);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      background: AppColors.bg,
      surface: AppColors.surface,
      primary: AppColors.red,
      secondary: AppColors.indigo,
      tertiary: AppColors.yellow,
      onPrimary: AppColors.white,
      onSurface: AppColors.white,
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.w900),
      displayMedium: TextStyle(color: AppColors.white, fontWeight: FontWeight.w800),
      titleLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: AppColors.textMuted),
      bodyMedium: TextStyle(color: AppColors.textMuted),
      labelSmall: TextStyle(color: AppColors.textSub),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.red,
        foregroundColor: AppColors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
