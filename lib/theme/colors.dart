import 'package:flutter/material.dart';

class AppColors {
  // Neon Arcade Palette
  static const Color bg         = Color(0xFF0C0A14);
  static const Color surface    = Color(0xFF1C1830);
  static const Color surface2   = Color(0xFF262040);
  static const Color red        = Color(0xFFE11D48);
  static const Color redDark    = Color(0xFF4F0C19);
  static const Color orange     = Color(0xFFF97316);
  static const Color orangeDark = Color(0xFF4E2307);
  static const Color yellow     = Color(0xFFFACC15);
  static const Color green      = Color(0xFF34D399);
  static const Color greenDark  = Color(0xFF104228);
  static const Color indigo     = Color(0xFF818CF8);
  static const Color indigoDark = Color(0xFF121038);
  static const Color purple     = Color(0xFFA855F7);
  static const Color purpleDark = Color(0xFF2D0A51);
  static const Color white      = Color(0xFFFFFFFF);
  static const Color textMuted  = Color(0xFFB3AED1);
  static const Color textSub    = Color(0xFF817D9E);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.dark(
      primary:   AppColors.red,
      secondary: AppColors.indigo,
      surface:   AppColors.surface,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.white,    fontSize: 52, fontWeight: FontWeight.w900),
      displayMedium:TextStyle(color: AppColors.white,    fontSize: 44, fontWeight: FontWeight.w900),
      headlineLarge:TextStyle(color: AppColors.white,    fontSize: 32, fontWeight: FontWeight.w800),
      headlineMedium:TextStyle(color: AppColors.white,   fontSize: 24, fontWeight: FontWeight.w700),
      titleLarge:   TextStyle(color: AppColors.white,    fontSize: 18, fontWeight: FontWeight.w700),
      titleMedium:  TextStyle(color: AppColors.white,    fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge:    TextStyle(color: AppColors.textMuted, fontSize: 15),
      bodyMedium:   TextStyle(color: AppColors.textMuted, fontSize: 13),
      labelSmall:   TextStyle(color: AppColors.textSub,  fontSize: 10),
    ),
  );
}
