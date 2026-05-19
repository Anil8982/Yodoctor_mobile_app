import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand Hex Tokens ────────────────────────────
  static const Color yoBlue = Color(0xFF1565C0);
  static const Color yoBlueDark = Color(0xFF0D47A1);
  static const Color yoBlueLight = Color(0xFFE3F0FF);

  static const Color yoGreen = Color(0xFF2E7D32);
  static const Color yoGreenDark = Color(0xFF1B5E20);
  static const Color yoGreenLight = Color(0xFFE8F5E9);

  // Statuses & Typography Tokens
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57F17);
  static const Color textPrimary = Color(0xFF0D1B2A);
  static const Color textSecondary = Color(0xFF546E7A);
  static const Color textHint = Color(0xFF90A4AE);

  // Base Neutrals
  static const Color background = Color(0xFFF5F9FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFCFD8DC);

  // Input Fields Specific
  static const Color inputFill = Color(0xFFF0F6FF);
  static const Color inputFillGreen = Color(0xFFF1F8F1);

  // ── Core Brand Gradients ──────────────────────────────
  static const LinearGradient doctorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
  );

  static const LinearGradient patientGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
  );

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF1565C0), Color(0xFF2E7D32)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEBF3FF), Color(0xFFF0F8F0), Color(0xFFFFFFFF)],
  );

  // ── 🩺 1. DOCTOR SCHEME (45 Color Roles) ──────────────────
  static const ColorScheme doctorColorScheme = ColorScheme.light(
    primary: yoBlue,
    onPrimary: Colors.white,
    primaryContainer: yoBlueLight,
    onPrimaryContainer: yoBlueDark,
    primaryFixed: yoBlueLight,
    primaryFixedDim: Color(0xFF90CAF9),
    onPrimaryFixed: yoBlueDark,
    onPrimaryFixedVariant: Color(0xFF1976D2),
    secondary: yoGreen,
    onSecondary: Colors.white,
    secondaryContainer: yoGreenLight,
    onSecondaryContainer: yoGreenDark,
    secondaryFixed: yoGreenLight,
    secondaryFixedDim: Color(0xFFA5D6A7),
    onSecondaryFixed: yoGreenDark,
    onSecondaryFixedVariant: Color(0xFF388E3C),
    tertiary: Color(0xFF00ACC1),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFE0F7FA),
    onTertiaryContainer: Color(0xFF006064),
    tertiaryFixed: Color(0xFFE0F7FA),
    tertiaryFixedDim: Color(0xFF80DEEA),
    onTertiaryFixed: Color(0xFF006064),
    onTertiaryFixedVariant: Color(0xFF00838F),
    surface: surface,
    onSurface: textPrimary,
    onSurfaceVariant: textSecondary,
    surfaceDim: Color(0xFFCFD8DC),
    surfaceBright: Color(0xFFECEFF1),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF8F9FA),
    surfaceContainer: background,
    surfaceContainerHigh: Color(0xFFECEFF1),
    surfaceContainerHighest: Color(0xFFE0E0E0),
    surfaceTint: yoBlue,
    error: error,
    onError: Colors.white,
    errorContainer: Color(0xFFFFEBEE),
    onErrorContainer: Color(0xFFC62828),
    outline: divider,
    outlineVariant: Color(0xFFB0BEC5),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF263238),
    inversePrimary: Color(0xFF90CAF9),
  );

  // ── 👤 2. PATIENT SCHEME (45 Color Roles) ─────────────────
  static const ColorScheme patientColorScheme = ColorScheme.light(
    primary: yoGreen,
    onPrimary: Colors.white,
    primaryContainer: yoGreenLight,
    onPrimaryContainer: yoGreenDark,
    primaryFixed: yoGreenLight,
    primaryFixedDim: Color(0xFFA5D6A7),
    onPrimaryFixed: yoGreenDark,
    onPrimaryFixedVariant: Color(0xFF388E3C),
    secondary: yoBlue,
    onSecondary: Colors.white,
    secondaryContainer: yoBlueLight,
    onSecondaryContainer: yoBlueDark,
    secondaryFixed: yoBlueLight,
    secondaryFixedDim: Color(0xFF90CAF9),
    onSecondaryFixed: yoBlueDark,
    onSecondaryFixedVariant: Color(0xFF1976D2),
    tertiary: Color(0xFF8E24AA),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFF3E5F5),
    onTertiaryContainer: Color(0xFF4A148C),
    tertiaryFixed: Color(0xFFF3E5F5),
    tertiaryFixedDim: Color(0xFFCE93D8),
    onTertiaryFixed: Color(0xFF4A148C),
    onTertiaryFixedVariant: Color(0xFF6A1B9A),
    surface: surface,
    onSurface: textPrimary,
    onSurfaceVariant: textSecondary,
    surfaceDim: Color(0xFFE8F5E9),
    surfaceBright: Color(0xFFF1F8F1),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF5FBF5),
    surfaceContainer: background,
    surfaceContainerHigh: Color(0xFFE8F5E9),
    surfaceContainerHighest: Color(0xFFC8E6C9),
    surfaceTint: yoGreen,
    error: error,
    onError: Colors.white,
    errorContainer: Color(0xFFFFEBEE),
    onErrorContainer: Color(0xFFC62828),
    outline: divider,
    outlineVariant: Color(0xFFB0BEC5),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF263238),
    inversePrimary: Color(0xFFA5D6A7),
  );
}