// import 'package:flutter/material.dart';
//
// class AppColors {
//   AppColors._();
//
//   // ── Brand Hex Tokens ────────────────────────────
//   static const Color yoBlue = Color(0xFF1565C0);
//   static const Color yoBlueDark = Color(0xFF0D47A1);
//   static const Color yoBlueLight = Color(0xFFE3F0FF);
//
//   static const Color yoGreen = Color(0xFF2E7D32);
//   static const Color yoGreenDark = Color(0xFF1B5E20);
//   static const Color yoGreenLight = Color(0xFFE8F5E9);
//
//   static const Color yoPurple = Color(0xFF8A63B5);
//   static const Color yoPurpleDark = Color(0xFF6F42A6);
//   static const Color yoPurpleLight = Color(0xFFEDE3F8);
//
//   // ── Status Colors ────────────────────────────────
//
// // Light
//   static const Color success = Color(0xFF2E7D32);
//   static const Color warning = Color(0xFFF57F17);
//   static const Color error = Color(0xFFD32F2F);
//   static const Color info = Color(0xFF1565C0);
//   static const Color pending = Color(0xFFEF6C00);
//   static const Color cancelled = Color(0xFF757575);
//   static const Color active = Color(0xFF2E7D32);
//   static const Color inactive = Color(0xFF757575);
//
//   // Dark
//   static const Color successDark = Color(0xFF81C784);
//   static const Color warningDark = Color(0xFFFFB74D);
//   static const Color errorDark = Color(0xFFEF9A9A);
//   static const Color infoDark = Color(0xFF64B5F6);
//   static const Color pendingDark = Color(0xFFFFB74D);
//   static const Color cancelledDark = Color(0xFFBDBDBD);
//   static const Color activeDark = Color(0xFF81C784);
//   static const Color inactiveDark = Color(0xFFBDBDBD);
//
//   // ── Typography Tokens ────────────────────────────
//   static const Color textPrimary = Color(0xFF0D1B2A);
//   static const Color textSecondary = Color(0xFF546E7A);
//   static const Color textHint = Color(0xFF90A4AE);
//
//   // Base Neutrals
//   static const Color background = Color(0xFFF5F9FF);
//   static const Color surface = Color(0xFFFFFFFF);
//   static const Color divider = Color(0xFFCFD8DC);
//
//   // Input Fields Specific
//   static const Color inputFill = Color(0xFFF0F6FF);
//   static const Color inputFillGreen = Color(0xFFF1F8F1);
//
//   // ── Core Brand Gradients ──────────────────────────────
//   static const LinearGradient doctorGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
//   );
//
//   static const LinearGradient patientGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
//   );
//
//   static const LinearGradient adminGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFF6F42A6), Color(0xFF9C74C9)],
//   );
//
//   static const LinearGradient brandGradient = LinearGradient(
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//     colors: [Color(0xFF1565C0), Color(0xFF2E7D32)],
//   );
//
//   static const LinearGradient backgroundGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFFEBF3FF), Color(0xFFF0F8F0), Color(0xFFFFFFFF)],
//   );
//
//   // ── 🩺 1. DOCTOR SCHEME (45 Color Roles) ──────────────────
//   static const ColorScheme doctorColorScheme = ColorScheme.light(
//     primary: yoBlue,
//     onPrimary: Colors.white,
//     primaryContainer: yoBlueLight,
//     onPrimaryContainer: yoBlueDark,
//     primaryFixed: yoBlueLight,
//     primaryFixedDim: Color(0xFF90CAF9),
//     onPrimaryFixed: yoBlueDark,
//     onPrimaryFixedVariant: Color(0xFF1976D2),
//     secondary: yoGreen,
//     onSecondary: Colors.white,
//     secondaryContainer: yoGreenLight,
//     onSecondaryContainer: yoGreenDark,
//     secondaryFixed: yoGreenLight,
//     secondaryFixedDim: Color(0xFFA5D6A7),
//     onSecondaryFixed: yoGreenDark,
//     onSecondaryFixedVariant: Color(0xFF388E3C),
//     tertiary: Color(0xFF00ACC1),
//     onTertiary: Colors.white,
//     tertiaryContainer: Color(0xFFE0F7FA),
//     onTertiaryContainer: Color(0xFF006064),
//     tertiaryFixed: Color(0xFFE0F7FA),
//     tertiaryFixedDim: Color(0xFF80DEEA),
//     onTertiaryFixed: Color(0xFF006064),
//     onTertiaryFixedVariant: Color(0xFF00838F),
//     surface: surface,
//     onSurface: textPrimary,
//     onSurfaceVariant: textSecondary,
//     surfaceDim: Color(0xFFCFD8DC),
//     surfaceBright: Color(0xFFECEFF1),
//     surfaceContainerLowest: Colors.white,
//     surfaceContainerLow: Color(0xFFF8F9FA),
//     surfaceContainer: background,
//     surfaceContainerHigh: Color(0xFFECEFF1),
//     surfaceContainerHighest: Color(0xFFE0E0E0),
//     surfaceTint: yoBlue,
//     error: error,
//     onError: Colors.white,
//     errorContainer: Color(0xFFFFEBEE),
//     onErrorContainer: Color(0xFFC62828),
//     outline: divider,
//     outlineVariant: Color(0xFFB0BEC5),
//     shadow: Colors.black,
//     scrim: Colors.black,
//     inverseSurface: Color(0xFF263238),
//     inversePrimary: Color(0xFF90CAF9),
//   );
//
//   // ── 👤 2. PATIENT SCHEME (45 Color Roles) ─────────────────
//   static const ColorScheme patientColorScheme = ColorScheme.light(
//     primary: yoGreen,
//     onPrimary: Colors.white,
//     primaryContainer: yoGreenLight,
//     onPrimaryContainer: yoGreenDark,
//     primaryFixed: yoGreenLight,
//     primaryFixedDim: Color(0xFFA5D6A7),
//     onPrimaryFixed: yoGreenDark,
//     onPrimaryFixedVariant: Color(0xFF388E3C),
//     secondary: yoBlue,
//     onSecondary: Colors.white,
//     secondaryContainer: yoBlueLight,
//     onSecondaryContainer: yoBlueDark,
//     secondaryFixed: yoBlueLight,
//     secondaryFixedDim: Color(0xFF90CAF9),
//     onSecondaryFixed: yoBlueDark,
//     onSecondaryFixedVariant: Color(0xFF1976D2),
//     tertiary: Color(0xFF8E24AA),
//     onTertiary: Colors.white,
//     tertiaryContainer: Color(0xFFF3E5F5),
//     onTertiaryContainer: Color(0xFF4A148C),
//     tertiaryFixed: Color(0xFFF3E5F5),
//     tertiaryFixedDim: Color(0xFFCE93D8),
//     onTertiaryFixed: Color(0xFF4A148C),
//     onTertiaryFixedVariant: Color(0xFF6A1B9A),
//     surface: surface,
//     onSurface: textPrimary,
//     onSurfaceVariant: textSecondary,
//     surfaceDim: Color(0xFFE8F5E9),
//     surfaceBright: Color(0xFFF1F8F1),
//     surfaceContainerLowest: Colors.white,
//     surfaceContainerLow: Color(0xFFF5FBF5),
//     surfaceContainer: background,
//     surfaceContainerHigh: Color(0xFFE8F5E9),
//     surfaceContainerHighest: Color(0xFFC8E6C9),
//     surfaceTint: yoGreen,
//     error: error,
//     onError: Colors.white,
//     errorContainer: Color(0xFFFFEBEE),
//     onErrorContainer: Color(0xFFC62828),
//     outline: divider,
//     outlineVariant: Color(0xFFB0BEC5),
//     shadow: Colors.black,
//     scrim: Colors.black,
//     inverseSurface: Color(0xFF263238),
//     inversePrimary: Color(0xFFA5D6A7),
//   );
//
//   // ── 👤 3. ADMIN SCHEME (45 Color Roles) ─────────────────
//   static const ColorScheme adminColorScheme = ColorScheme.light(
//     primary: yoPurple,
//     onPrimary: Colors.white,
//     primaryContainer: yoPurpleLight,
//     onPrimaryContainer: yoPurpleDark,
//     primaryFixed: yoPurpleLight,
//     primaryFixedDim: Color(0xFFA5D6A7),
//     onPrimaryFixed: yoPurpleDark,
//     onPrimaryFixedVariant: Color(0xFF388E3C),
//     secondary: yoBlue,
//     onSecondary: Colors.white,
//     secondaryContainer: yoPurpleLight,
//     onSecondaryContainer: yoPurpleDark,
//     secondaryFixed: yoPurpleLight,
//     secondaryFixedDim: Color(0xFF90CAF9),
//     onSecondaryFixed: yoPurpleDark,
//     onSecondaryFixedVariant: Color(0xFF1976D2),
//     tertiary: Color(0xFF8E24AA),
//     onTertiary: Colors.white,
//     tertiaryContainer: Color(0xFFF3E5F5),
//     onTertiaryContainer: Color(0xFF4A148C),
//     tertiaryFixed: Color(0xFFF3E5F5),
//     tertiaryFixedDim: Color(0xFFCE93D8),
//     onTertiaryFixed: Color(0xFF4A148C),
//     onTertiaryFixedVariant: Color(0xFF6A1B9A),
//     surface: surface,
//     onSurface: textPrimary,
//     onSurfaceVariant: textSecondary,
//     surfaceDim: Color(0xFFE8F5E9),
//     surfaceBright: Color(0xFFF1F8F1),
//     surfaceContainerLowest: Colors.white,
//     surfaceContainerLow: Color(0xFFF5FBF5),
//     surfaceContainer: background,
//     surfaceContainerHigh: Color(0xFFE8F5E9),
//     surfaceContainerHighest: Color(0xFFC8E6C9),
//     surfaceTint: yoPurple,
//     error: error,
//     onError: Colors.white,
//     errorContainer: Color(0xFFFFEBEE),
//     onErrorContainer: Color(0xFFC62828),
//     outline: divider,
//     outlineVariant: Color(0xFFB0BEC5),
//     shadow: Colors.black,
//     scrim: Colors.black,
//     inverseSurface: Color(0xFF263238),
//     inversePrimary: Color(0xFFA5D6A7),
//   );
// }


import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand colors
  static const Color yoBlue = Color(0xFF1565C0);
  static const Color yoBlueDark = Color(0xFF0D47A1);
  static const Color yoBlueLight = Color(0xFFE3F0FF);

  static const Color yoGreen = Color(0xFF2E7D32);
  static const Color yoGreenDark = Color(0xFF1B5E20);
  static const Color yoGreenLight = Color(0xFFE8F5E9);

  static const Color yoPurple = Color(0xFF8A63B5);
  static const Color yoPurpleDark = Color(0xFF6F42A6);
  static const Color yoPurpleLight = Color(0xFFEDE3F8);

  // Status colors
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57F17);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1565C0);
  static const Color pending = Color(0xFFEF6C00);
  static const Color cancelled = Color(0xFF757575);
  static const Color active = Color(0xFF2E7D32);
  static const Color inactive = Color(0xFF757575);

  // Dark status colors
  static const Color successDark = Color(0xFF66BB6A);
  static const Color warningDark = Color(0xFFFFA726);
  static const Color errorDark = Color(0xFFEF5350);
  static const Color infoDark = Color(0xFF42A5F5);
  static const Color pendingDark = Color(0xFFFFA726);
  static const Color cancelledDark = Color(0xFF9E9E9E);
  static const Color activeDark = Color(0xFF66BB6A);
  static const Color inactiveDark = Color(0xFF9E9E9E);
// On-status colors
  static const Color onSuccess = Color(0xFFF1F8F6);
  static const Color onWarning = Color(0xFFFFF8E1);
  static const Color onError = Color(0xFFFFEBEE);
  static const Color onInfo = Color(0xFFE3F2FD);
  static const Color onPending = Color(0xFFFFF8E1);
  static const Color onCancelled = Color(0xFFFAFAFA);
  static const Color onActive = Color(0xFFF1F8F6);
  static const Color onInactive = Color(0xFFFAFAFA);


  // Typography colors
  static const Color textPrimary = Color(0xFF0D1B2A);
  static const Color textSecondary = Color(0xFF546E7A);
  static const Color textHint = Color(0xFF90A4AE);

  // Base neutrals
  static const Color background = Color(0xFFF5F9FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFCFD8DC);

  // Input colors
  static const Color inputFill = Color(0xFFF0F6FF);
  static const Color inputFillGreen = Color(0xFFF1F8F1);

  // Doctor dark theme colors
  static const Color doctorDarkSurface = Color(0xFF09121B);
  static const Color doctorDarkSurfaceVariant = Color(0xFF0A0A0A);
  static const Color doctorDarkBackground = Color(0xFF04080D);
  static const Color doctorDarkDivider = Color(0xFF192A3B);
  static const Color doctorDarkSurfaceContainer = Color(0xFF0A0A0A);
  static const Color doctorDarkSurfaceHigh = Color(0xFF112234);
  static const Color doctorDarkSurfaceHighest = Color(0xFF182D42);

// Patient dark theme colors
  static const Color patientDarkSurface = Color(0xFF09130D);
  static const Color patientDarkSurfaceVariant = Color(0xFF0A0A0A);
  static const Color patientDarkBackground = Color(0xFF040906);
  static const Color patientDarkDivider = Color(0xFF183222);
  static const Color patientDarkSurfaceContainer = Color(0xFF0A0A0A);
  static const Color patientDarkSurfaceHigh = Color(0xFF112619);
  static const Color patientDarkSurfaceHighest = Color(0xFF193624);

  // Admin dark theme colors
  static const Color adminDarkSurface = Color(0xFF120D1C);
  static const Color adminDarkSurfaceVariant = Color(0xFF1E1630);
  static const Color adminDarkBackground = Color(0xFF0C0814);
  static const Color adminDarkDivider = Color(0xFF2D2145);
  static const Color adminDarkSurfaceContainer = Color(0xFF171126);
  static const Color adminDarkSurfaceHigh = Color(0xFF201736);
  static const Color adminDarkSurfaceHighest = Color(0xFF2B1F47);

  // Dark text colors
  static const Color darkTextPrimary = Color(0xFFE2E8F0);
  static const Color darkTextSecondary = Color(0xFFA0AEC0);
  static const Color darkTextHint = Color(0xFF64748B);

  // Doctor color scheme
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

  // Patient color scheme
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

  // Admin color scheme
  static const ColorScheme adminColorScheme = ColorScheme.light(
    primary: yoPurple,
    onPrimary: Colors.white,
    primaryContainer: yoPurpleLight,
    onPrimaryContainer: yoPurpleDark,
    primaryFixed: yoPurpleLight,
    primaryFixedDim: Color(0xFFA5D6A7),
    onPrimaryFixed: yoPurpleDark,
    onPrimaryFixedVariant: Color(0xFF388E3C),
    secondary: yoBlue,
    onSecondary: Colors.white,
    secondaryContainer: yoPurpleLight,
    onSecondaryContainer: yoPurpleDark,
    secondaryFixed: yoPurpleLight,
    secondaryFixedDim: Color(0xFF90CAF9),
    onSecondaryFixed: yoPurpleDark,
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
    surfaceTint: yoPurple,
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

  // Dark color schemes
  // Doctor dark color scheme
  static const ColorScheme doctorDarkColorScheme = ColorScheme.dark(
    primary: Color(0xFF1E88E5),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF0D47A1),
    onPrimaryContainer: Color(0xFF90CAF9),
    primaryFixed: Color(0xFF42A5F5),
    primaryFixedDim: Color(0xFF1976D2),
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: Color(0xFF64B5F6),
    secondary: Color(0xFF43A047),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF1B5E20),
    onSecondaryContainer: Color(0xFFA5D6A7),
    secondaryFixed: Color(0xFF66BB6A),
    secondaryFixedDim: Color(0xFF388E3C),
    onSecondaryFixed: Colors.white,
    onSecondaryFixedVariant: Color(0xFF81C784),
    tertiary: Color(0xFF00ACC1),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF006064),
    onTertiaryContainer: Color(0xFF80DEEA),
    tertiaryFixed: Color(0xFF4DD0E1),
    tertiaryFixedDim: Color(0xFF0097A7),
    onTertiaryFixed: Colors.white,
    onTertiaryFixedVariant: Color(0xFF26C6DA),
    surface: doctorDarkSurface,
    onSurface: darkTextPrimary,
    onSurfaceVariant: darkTextSecondary,
    surfaceDim: doctorDarkBackground,
    surfaceBright: doctorDarkSurfaceHigh,
    surfaceContainerLowest: Color(0xFF040A12),
    surfaceContainerLow: doctorDarkSurfaceVariant,
    surfaceContainer: doctorDarkSurfaceContainer,
    surfaceContainerHigh: doctorDarkSurfaceHigh,
    surfaceContainerHighest: doctorDarkSurfaceHighest,
    surfaceTint: Color(0xFF1E88E5),
    error: errorDark,
    onError: Colors.white,
    errorContainer: Color(0xFFB71C1C),
    onErrorContainer: Color(0xFFFFCDD2),
    outline: doctorDarkDivider,
    outlineVariant: Color(0xFF2D4258),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Colors.white,
    inversePrimary: Color(0xFF1565C0),
  );

  // Patient dark color scheme
  static const ColorScheme patientDarkColorScheme = ColorScheme.dark(
    primary: Color(0xFF43A047),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF1B5E20),
    onPrimaryContainer: Color(0xFFA5D6A7),
    primaryFixed: Color(0xFF66BB6A),
    primaryFixedDim: Color(0xFF388E3C),
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: Color(0xFF81C784),
    secondary: Color(0xFF1E88E5),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF0D47A1),
    onSecondaryContainer: Color(0xFF90CAF9),
    secondaryFixed: Color(0xFF42A5F5),
    secondaryFixedDim: Color(0xFF1976D2),
    onSecondaryFixed: Colors.white,
    onSecondaryFixedVariant: Color(0xFF64B5F6),
    tertiary: Color(0xFF8E24AA),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF4A148C),
    onTertiaryContainer: Color(0xFFCE93D8),
    tertiaryFixed: Color(0xFFBA68C8),
    tertiaryFixedDim: Color(0xFF7B1FA2),
    onTertiaryFixed: Colors.white,
    onTertiaryFixedVariant: Color(0xFFCE93D8),
    surface: patientDarkSurface,
    onSurface: darkTextPrimary,
    onSurfaceVariant: darkTextSecondary,
    surfaceDim: patientDarkBackground,
    surfaceBright: patientDarkSurfaceHigh,
    surfaceContainerLowest: Color(0xFF040A06),
    surfaceContainerLow: patientDarkSurfaceVariant,
    surfaceContainer: patientDarkSurfaceContainer,
    surfaceContainerHigh: patientDarkSurfaceHigh,
    surfaceContainerHighest: patientDarkSurfaceHighest,
    surfaceTint: Color(0xFF43A047),
    error: errorDark,
    onError: Colors.white,
    errorContainer: Color(0xFFB71C1C),
    onErrorContainer: Color(0xFFFFCDD2),
    outline: patientDarkDivider,
    outlineVariant: Color(0xFF2D5238),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Colors.white,
    inversePrimary: Color(0xFF2E7D32),
  );

  // Admin dark color scheme
  static const ColorScheme adminDarkColorScheme = ColorScheme.dark(
    primary: Color(0xFF8E24AA),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF4A148C),
    onPrimaryContainer: Color(0xFFCE93D8),
    primaryFixed: Color(0xFFAB47BC),
    primaryFixedDim: Color(0xFF7B1FA2),
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: Color(0xFFBA68C8),
    secondary: Color(0xFF1E88E5),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF0D47A1),
    onSecondaryContainer: Color(0xFF90CAF9),
    secondaryFixed: Color(0xFF42A5F5),
    secondaryFixedDim: Color(0xFF1976D2),
    onSecondaryFixed: Colors.white,
    onSecondaryFixedVariant: Color(0xFF64B5F6),
    tertiary: Color(0xFF00ACC1),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF006064),
    onTertiaryContainer: Color(0xFF80DEEA),
    tertiaryFixed: Color(0xFF4DD0E1),
    tertiaryFixedDim: Color(0xFF0097A7),
    onTertiaryFixed: Colors.white,
    onTertiaryFixedVariant: Color(0xFF26C6DA),
    surface: adminDarkSurface,
    onSurface: darkTextPrimary,
    onSurfaceVariant: darkTextSecondary,
    surfaceDim: adminDarkBackground,
    surfaceBright: adminDarkSurfaceHigh,
    surfaceContainerLowest: Color(0xFF080510),
    surfaceContainerLow: adminDarkSurfaceVariant,
    surfaceContainer: adminDarkSurfaceContainer,
    surfaceContainerHigh: adminDarkSurfaceHigh,
    surfaceContainerHighest: adminDarkSurfaceHighest,
    surfaceTint: Color(0xFF8E24AA),
    error: errorDark,
    onError: Colors.white,
    errorContainer: Color(0xFFB71C1C),
    onErrorContainer: Color(0xFFFFCDD2),
    outline: adminDarkDivider,
    outlineVariant: Color(0xFF463062),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Colors.white,
    inversePrimary: Color(0xFF6F42A6),
  );
}