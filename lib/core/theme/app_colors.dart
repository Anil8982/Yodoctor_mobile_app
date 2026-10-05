// import 'package:flutter/material.dart';
//
// class AppColors {
//   AppColors._();
//
//   // Brand colors
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
//   // Status colors
//   static const Color success = Color(0xFF2E7D32);
//   static const Color warning = Color(0xFFF57F17);
//   static const Color error = Color(0xFFD32F2F);
//   static const Color info = Color(0xFF1565C0);
//   static const Color pending = Color(0xFFEF6C00);
//   static const Color cancelled = Color(0xFF757575);
//   static const Color active = Color(0xFF2E7D32);
//   static const Color inactive = Color(0xFF757575);
//
//   // Dark status colors
//   static const Color successDark = Color(0xFF66BB6A);
//   static const Color warningDark = Color(0xFFFFA726);
//   static const Color errorDark = Color(0xFFEF5350);
//   static const Color infoDark = Color(0xFF42A5F5);
//   static const Color pendingDark = Color(0xFFFFA726);
//   static const Color cancelledDark = Color(0xFF9E9E9E);
//   static const Color activeDark = Color(0xFF66BB6A);
//   static const Color inactiveDark = Color(0xFF9E9E9E);
// // On-status colors
//   static const Color onSuccess = Color(0xFFF1F8F6);
//   static const Color onWarning = Color(0xFFFFF8E1);
//   static const Color onError = Color(0xFFFFEBEE);
//   static const Color onInfo = Color(0xFFE3F2FD);
//   static const Color onPending = Color(0xFFFFF8E1);
//   static const Color onCancelled = Color(0xFFFAFAFA);
//   static const Color onActive = Color(0xFFF1F8F6);
//   static const Color onInactive = Color(0xFFFAFAFA);
//
//
//   // Typography colors
//   static const Color textPrimary = Color(0xFF0D1B2A);
//   static const Color textSecondary = Color(0xFF546E7A);
//   static const Color textHint = Color(0xFF90A4AE);
//
//   // Base neutrals
//   static const Color background = Color(0xFFF5F9FF);
//   static const Color surface = Color(0xFFFFFFFF);
//   static const Color divider = Color(0xFFCFD8DC);
//
//   // Input colors
//   static const Color inputFill = Color(0xFFF0F6FF);
//   static const Color inputFillGreen = Color(0xFFF1F8F1);
//
//   // Doctor dark theme colors
//   static const Color doctorDarkSurface = Color(0xFF09121B);
//   static const Color doctorDarkSurfaceVariant = Color(0xFF0A0A0A);
//   static const Color doctorDarkBackground = Color(0xFF04080D);
//   static const Color doctorDarkDivider = Color(0xFF192A3B);
//   static const Color doctorDarkSurfaceContainer = Color(0xFF0A0A0A);
//   static const Color doctorDarkSurfaceHigh = Color(0xFF112234);
//   static const Color doctorDarkSurfaceHighest = Color(0xFF182D42);
//
// // Patient dark theme colors
//   static const Color patientDarkSurface = Color(0xFF09130D);
//   static const Color patientDarkSurfaceVariant = Color(0xFF0A0A0A);
//   static const Color patientDarkBackground = Color(0xFF040906);
//   static const Color patientDarkDivider = Color(0xFF183222);
//   static const Color patientDarkSurfaceContainer = Color(0xFF0A0A0A);
//   static const Color patientDarkSurfaceHigh = Color(0xFF112619);
//   static const Color patientDarkSurfaceHighest = Color(0xFF193624);
//
//   // Admin dark theme colors
//   static const Color adminDarkSurface = Color(0xFF120D1C);
//   static const Color adminDarkSurfaceVariant = Color(0xFF1E1630);
//   static const Color adminDarkBackground = Color(0xFF0C0814);
//   static const Color adminDarkDivider = Color(0xFF2D2145);
//   static const Color adminDarkSurfaceContainer = Color(0xFF171126);
//   static const Color adminDarkSurfaceHigh = Color(0xFF201736);
//   static const Color adminDarkSurfaceHighest = Color(0xFF2B1F47);
//
//   // Dark text colors
//   static const Color darkTextPrimary = Color(0xFFE2E8F0);
//   static const Color darkTextSecondary = Color(0xFFA0AEC0);
//   static const Color darkTextHint = Color(0xFF64748B);
//
//   // Doctor color scheme
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
//   // Patient color scheme
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
//   // Admin color scheme
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
//
//   // Dark color schemes
//   // Doctor dark color scheme
//   static const ColorScheme doctorDarkColorScheme = ColorScheme.dark(
//     primary: Color(0xFF1E88E5),
//     onPrimary: Colors.white,
//     primaryContainer: Color(0xFF0D47A1),
//     onPrimaryContainer: Color(0xFF90CAF9),
//     primaryFixed: Color(0xFF42A5F5),
//     primaryFixedDim: Color(0xFF1976D2),
//     onPrimaryFixed: Colors.white,
//     onPrimaryFixedVariant: Color(0xFF64B5F6),
//     secondary: Color(0xFF43A047),
//     onSecondary: Colors.white,
//     secondaryContainer: Color(0xFF1B5E20),
//     onSecondaryContainer: Color(0xFFA5D6A7),
//     secondaryFixed: Color(0xFF66BB6A),
//     secondaryFixedDim: Color(0xFF388E3C),
//     onSecondaryFixed: Colors.white,
//     onSecondaryFixedVariant: Color(0xFF81C784),
//     tertiary: Color(0xFF00ACC1),
//     onTertiary: Colors.white,
//     tertiaryContainer: Color(0xFF006064),
//     onTertiaryContainer: Color(0xFF80DEEA),
//     tertiaryFixed: Color(0xFF4DD0E1),
//     tertiaryFixedDim: Color(0xFF0097A7),
//     onTertiaryFixed: Colors.white,
//     onTertiaryFixedVariant: Color(0xFF26C6DA),
//     surface: doctorDarkSurface,
//     onSurface: darkTextPrimary,
//     onSurfaceVariant: darkTextSecondary,
//     surfaceDim: doctorDarkBackground,
//     surfaceBright: doctorDarkSurfaceHigh,
//     surfaceContainerLowest: Color(0xFF040A12),
//     surfaceContainerLow: doctorDarkSurfaceVariant,
//     surfaceContainer: doctorDarkSurfaceContainer,
//     surfaceContainerHigh: doctorDarkSurfaceHigh,
//     surfaceContainerHighest: doctorDarkSurfaceHighest,
//     surfaceTint: Color(0xFF1E88E5),
//     error: errorDark,
//     onError: Colors.white,
//     errorContainer: Color(0xFFB71C1C),
//     onErrorContainer: Color(0xFFFFCDD2),
//     outline: doctorDarkDivider,
//     outlineVariant: Color(0xFF2D4258),
//     shadow: Colors.black,
//     scrim: Colors.black,
//     inverseSurface: Colors.white,
//     inversePrimary: Color(0xFF1565C0),
//   );
//
//   // Patient dark color scheme
//   static const ColorScheme patientDarkColorScheme = ColorScheme.dark(
//     primary: Color(0xFF43A047),
//     onPrimary: Colors.white,
//     primaryContainer: Color(0xFF1B5E20),
//     onPrimaryContainer: Color(0xFFA5D6A7),
//     primaryFixed: Color(0xFF66BB6A),
//     primaryFixedDim: Color(0xFF388E3C),
//     onPrimaryFixed: Colors.white,
//     onPrimaryFixedVariant: Color(0xFF81C784),
//     secondary: Color(0xFF1E88E5),
//     onSecondary: Colors.white,
//     secondaryContainer: Color(0xFF0D47A1),
//     onSecondaryContainer: Color(0xFF90CAF9),
//     secondaryFixed: Color(0xFF42A5F5),
//     secondaryFixedDim: Color(0xFF1976D2),
//     onSecondaryFixed: Colors.white,
//     onSecondaryFixedVariant: Color(0xFF64B5F6),
//     tertiary: Color(0xFF8E24AA),
//     onTertiary: Colors.white,
//     tertiaryContainer: Color(0xFF4A148C),
//     onTertiaryContainer: Color(0xFFCE93D8),
//     tertiaryFixed: Color(0xFFBA68C8),
//     tertiaryFixedDim: Color(0xFF7B1FA2),
//     onTertiaryFixed: Colors.white,
//     onTertiaryFixedVariant: Color(0xFFCE93D8),
//     surface: patientDarkSurface,
//     onSurface: darkTextPrimary,
//     onSurfaceVariant: darkTextSecondary,
//     surfaceDim: patientDarkBackground,
//     surfaceBright: patientDarkSurfaceHigh,
//     surfaceContainerLowest: Color(0xFF040A06),
//     surfaceContainerLow: patientDarkSurfaceVariant,
//     surfaceContainer: patientDarkSurfaceContainer,
//     surfaceContainerHigh: patientDarkSurfaceHigh,
//     surfaceContainerHighest: patientDarkSurfaceHighest,
//     surfaceTint: Color(0xFF43A047),
//     error: errorDark,
//     onError: Colors.white,
//     errorContainer: Color(0xFFB71C1C),
//     onErrorContainer: Color(0xFFFFCDD2),
//     outline: patientDarkDivider,
//     outlineVariant: Color(0xFF2D5238),
//     shadow: Colors.black,
//     scrim: Colors.black,
//     inverseSurface: Colors.white,
//     inversePrimary: Color(0xFF2E7D32),
//   );
//
//   // Admin dark color scheme
//   static const ColorScheme adminDarkColorScheme = ColorScheme.dark(
//     primary: Color(0xFF8E24AA),
//     onPrimary: Colors.white,
//     primaryContainer: Color(0xFF4A148C),
//     onPrimaryContainer: Color(0xFFCE93D8),
//     primaryFixed: Color(0xFFAB47BC),
//     primaryFixedDim: Color(0xFF7B1FA2),
//     onPrimaryFixed: Colors.white,
//     onPrimaryFixedVariant: Color(0xFFBA68C8),
//     secondary: Color(0xFF1E88E5),
//     onSecondary: Colors.white,
//     secondaryContainer: Color(0xFF0D47A1),
//     onSecondaryContainer: Color(0xFF90CAF9),
//     secondaryFixed: Color(0xFF42A5F5),
//     secondaryFixedDim: Color(0xFF1976D2),
//     onSecondaryFixed: Colors.white,
//     onSecondaryFixedVariant: Color(0xFF64B5F6),
//     tertiary: Color(0xFF00ACC1),
//     onTertiary: Colors.white,
//     tertiaryContainer: Color(0xFF006064),
//     onTertiaryContainer: Color(0xFF80DEEA),
//     tertiaryFixed: Color(0xFF4DD0E1),
//     tertiaryFixedDim: Color(0xFF0097A7),
//     onTertiaryFixed: Colors.white,
//     onTertiaryFixedVariant: Color(0xFF26C6DA),
//     surface: adminDarkSurface,
//     onSurface: darkTextPrimary,
//     onSurfaceVariant: darkTextSecondary,
//     surfaceDim: adminDarkBackground,
//     surfaceBright: adminDarkSurfaceHigh,
//     surfaceContainerLowest: Color(0xFF080510),
//     surfaceContainerLow: adminDarkSurfaceVariant,
//     surfaceContainer: adminDarkSurfaceContainer,
//     surfaceContainerHigh: adminDarkSurfaceHigh,
//     surfaceContainerHighest: adminDarkSurfaceHighest,
//     surfaceTint: Color(0xFF8E24AA),
//     error: errorDark,
//     onError: Colors.white,
//     errorContainer: Color(0xFFB71C1C),
//     onErrorContainer: Color(0xFFFFCDD2),
//     outline: adminDarkDivider,
//     outlineVariant: Color(0xFF463062),
//     shadow: Colors.black,
//     scrim: Colors.black,
//     inverseSurface: Colors.white,
//     inversePrimary: Color(0xFF6F42A6),
//   );
// }


import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===========================================================================
  // BRAND COLORS
  // ===========================================================================

  // Doctor (Clinical Sapphire / Cyan Blue)
  static const Color yoBlue = Color(0xFF0284C7);
  static const Color yoBlueDark = Color(0xFF0369A1);
  static const Color yoBlueLight = Color(0xFFE0F2FE);

  // Patient (Vitality Emerald Green)
  static const Color yoGreen = Color(0xFF059669);
  static const Color yoGreenDark = Color(0xFF047857);
  static const Color yoGreenLight = Color(0xFFD1FAE5);

  // Admin (Royal Purple / Amethyst)
  static const Color yoPurple = Color(0xFF7C3AED);
  static const Color yoPurpleDark = Color(0xFF6D28D9);
  static const Color yoPurpleLight = Color(0xFFEDE9FE);

  // ===========================================================================
  // STATUS TOKENS (Solid Accents)
  // ===========================================================================

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);
  static const Color pending = Color(0xFFF97316);
  static const Color cancelled = Color(0xFF64748B);
  static const Color active = Color(0xFF10B981);
  static const Color inactive = Color(0xFF94A3B8);

  // Dark Status Accents
  static const Color successDark = Color(0xFF34D399);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color errorDark = Color(0xFFF87171);
  static const Color infoDark = Color(0xFF38BDF8);
  static const Color pendingDark = Color(0xFFFB923C);
  static const Color cancelledDark = Color(0xFF94A3B8);
  static const Color activeDark = Color(0xFF34D399);
  static const Color inactiveDark = Color(0xFF64748B);

  // ===========================================================================
  // STATUS BADGES & ON-STATUS TOKENS (Light vs Dark Adaptive)
  // ===========================================================================

  // --- Light Mode Status Badges ---
  static const Color successContainerLight = Color(0xFFECFDF5);
  static const Color onSuccessContainerLight = Color(0xFF065F46);

  static const Color warningContainerLight = Color(0xFFFFFBEB);
  static const Color onWarningContainerLight = Color(0xFF92400E);

  static const Color errorContainerLight = Color(0xFFFEF2F2);
  static const Color onErrorContainerLight = Color(0xFF991B1B);

  static const Color infoContainerLight = Color(0xFFF0F9FF);
  static const Color onInfoContainerLight = Color(0xFF075985);

  static const Color pendingContainerLight = Color(0xFFFFF7ED);
  static const Color onPendingContainerLight = Color(0xFF9A3412);

  static const Color cancelledContainerLight = Color(0xFFF8FAFC);
  static const Color onCancelledContainerLight = Color(0xFF475569);

  // --- Dark Mode Status Badges (High Contrast, No Eye-Strain) ---
  static const Color successContainerDark = Color(0xFF064E3B);
  static const Color onSuccessContainerDark = Color(0xFFA7F3D0);

  static const Color warningContainerDark = Color(0xFF451A03);
  static const Color onWarningContainerDark = Color(0xFFFDE68A);

  static const Color errorContainerDark = Color(0xFF450A0A);
  static const Color onErrorContainerDark = Color(0xFFFECACA);

  static const Color infoContainerDark = Color(0xFF082F49);
  static const Color onInfoContainerDark = Color(0xFFBAE6FD);

  static const Color pendingContainerDark = Color(0xFF431407);
  static const Color onPendingContainerDark = Color(0xFFFED7AA);

  static const Color cancelledContainerDark = Color(0xFF1E293B);
  static const Color onCancelledContainerDark = Color(0xFFCBD5E1);

  // Legacy aliases (Default to Light for backwards compatibility)
  static const Color onSuccess = onSuccessContainerLight;
  static const Color onWarning = onWarningContainerLight;
  static const Color onError = onErrorContainerLight;
  static const Color onInfo = onInfoContainerLight;
  static const Color onPending = onPendingContainerLight;
  static const Color onCancelled = onCancelledContainerLight;
  static const Color onActive = onSuccessContainerLight;
  static const Color onInactive = onCancelledContainerLight;

  // ===========================================================================
  // TYPOGRAPHY BASE TOKENS
  // ===========================================================================

  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textHint = Color(0xFF94A3B8); // Slate 400

  static const Color darkTextPrimary = Color(0xFFF1F5F9); // Slate 100
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextHint = Color(0xFF64748B); // Slate 500

  // ===========================================================================
  // LIGHT NEUTRALS & INPUTS
  // ===========================================================================

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);

  static const Color inputFill = Color(0xFFF1F5F9);
  static const Color inputFillGreen = Color(0xFFECFDF5);

  // ===========================================================================
  // DARK THEME OBSIDIAN FOUNDATION
  // ===========================================================================

  // 1. Doctor Dark (Deep Ocean Obsidian)
  static const Color doctorDarkBackground = Color(0xFF0B111A);
  static const Color doctorDarkSurface = Color(0xFF111A26);
  static const Color doctorDarkSurfaceContainer = Color(0xFF172333);
  static const Color doctorDarkSurfaceHigh = Color(0xFF1F2F44);
  static const Color doctorDarkSurfaceHighest = Color(0xFF283D56);
  static const Color doctorDarkDivider = Color(0xFF22354D);

  // 2. Patient Dark (Forest Pine Obsidian)
  static const Color patientDarkBackground = Color(0xFF0B1410);
  static const Color patientDarkSurface = Color(0xFF111E18);
  static const Color patientDarkSurfaceContainer = Color(0xFF172921);
  static const Color patientDarkSurfaceHigh = Color(0xFF1F372C);
  static const Color patientDarkSurfaceHighest = Color(0xFF29473A);
  static const Color patientDarkDivider = Color(0xFF223E31);

  // 3. Admin Dark (Midnight Amethyst Obsidian)
  static const Color adminDarkBackground = Color(0xFF100C1A);
  static const Color adminDarkSurface = Color(0xFF171224);
  static const Color adminDarkSurfaceContainer = Color(0xFF211A33);
  static const Color adminDarkSurfaceHigh = Color(0xFF2C2344);
  static const Color adminDarkSurfaceHighest = Color(0xFF3A2E59);
  static const Color adminDarkDivider = Color(0xFF33274F);

  // ===========================================================================
  // LIGHT COLOR SCHEMES
  // ===========================================================================

  // 1. Doctor Light Scheme
  static const ColorScheme doctorColorScheme = ColorScheme.light(
    primary: yoBlue,
    onPrimary: Colors.white,
    primaryContainer: yoBlueLight,
    onPrimaryContainer: yoBlueDark,
    primaryFixed: yoBlueLight,
    primaryFixedDim: Color(0xFFBAE6FD),
    onPrimaryFixed: yoBlueDark,
    onPrimaryFixedVariant: Color(0xFF0284C7),
    secondary: yoGreen,
    onSecondary: Colors.white,
    secondaryContainer: yoGreenLight,
    onSecondaryContainer: yoGreenDark,
    secondaryFixed: yoGreenLight,
    secondaryFixedDim: Color(0xFFA7F3D0),
    onSecondaryFixed: yoGreenDark,
    onSecondaryFixedVariant: Color(0xFF059669),
    tertiary: Color(0xFF0891B2),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFCFFAFE),
    onTertiaryContainer: Color(0xFF155E75),
    tertiaryFixed: Color(0xFFCFFAFE),
    tertiaryFixedDim: Color(0xFFA5F3FC),
    onTertiaryFixed: Color(0xFF155E75),
    onTertiaryFixedVariant: Color(0xFF0891B2),
    surface: surface,
    onSurface: textPrimary,
    onSurfaceVariant: textSecondary,
    surfaceDim: Color(0xFFF1F5F9),
    surfaceBright: surface,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF8FAFC),
    surfaceContainer: background,
    surfaceContainerHigh: Color(0xFFF1F5F9),
    surfaceContainerHighest: Color(0xFFE2E8F0),
    surfaceTint: yoBlue,
    error: error,
    onError: Colors.white,
    errorContainer: errorContainerLight,
    onErrorContainer: onErrorContainerLight,
    outline: divider,
    outlineVariant: Color(0xFFCBD5E1),
    shadow: Color(0x140F172A),
    scrim: Colors.black,
    inverseSurface: Color(0xFF0F172A),
    onInverseSurface: Color(0xFFF8FAFC),
    inversePrimary: Color(0xFF38BDF8),
  );

  // 2. Patient Light Scheme
  static const ColorScheme patientColorScheme = ColorScheme.light(
    primary: yoGreen,
    onPrimary: Colors.white,
    primaryContainer: yoGreenLight,
    onPrimaryContainer: yoGreenDark,
    primaryFixed: yoGreenLight,
    primaryFixedDim: Color(0xFFA7F3D0),
    onPrimaryFixed: yoGreenDark,
    onPrimaryFixedVariant: Color(0xFF059669),
    secondary: yoBlue,
    onSecondary: Colors.white,
    secondaryContainer: yoBlueLight,
    onSecondaryContainer: yoBlueDark,
    secondaryFixed: yoBlueLight,
    secondaryFixedDim: Color(0xFFBAE6FD),
    onSecondaryFixed: yoBlueDark,
    onSecondaryFixedVariant: Color(0xFF0284C7),
    tertiary: Color(0xFF0D9488),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFCCFBF1),
    onTertiaryContainer: Color(0xFF115E59),
    tertiaryFixed: Color(0xFFCCFBF1),
    tertiaryFixedDim: Color(0xFF99F6E4),
    onTertiaryFixed: Color(0xFF115E59),
    onTertiaryFixedVariant: Color(0xFF0D9488),
    surface: surface,
    onSurface: textPrimary,
    onSurfaceVariant: textSecondary,
    surfaceDim: Color(0xFFF1F5F9),
    surfaceBright: surface,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF8FAFC),
    surfaceContainer: background,
    surfaceContainerHigh: Color(0xFFF1F5F9),
    surfaceContainerHighest: Color(0xFFE2E8F0),
    surfaceTint: yoGreen,
    error: error,
    onError: Colors.white,
    errorContainer: errorContainerLight,
    onErrorContainer: onErrorContainerLight,
    outline: divider,
    outlineVariant: Color(0xFFCBD5E1),
    shadow: Color(0x140F172A),
    scrim: Colors.black,
    inverseSurface: Color(0xFF0F172A),
    onInverseSurface: Color(0xFFF8FAFC),
    inversePrimary: Color(0xFF34D399),
  );

  // 3. Admin Light Scheme
  static const ColorScheme adminColorScheme = ColorScheme.light(
    primary: yoPurple,
    onPrimary: Colors.white,
    primaryContainer: yoPurpleLight,
    onPrimaryContainer: yoPurpleDark,
    primaryFixed: yoPurpleLight,
    primaryFixedDim: Color(0xFFDDD6FE),
    onPrimaryFixed: yoPurpleDark,
    onPrimaryFixedVariant: Color(0xFF7C3AED),
    secondary: yoBlue,
    onSecondary: Colors.white,
    secondaryContainer: yoBlueLight,
    onSecondaryContainer: yoBlueDark,
    secondaryFixed: yoBlueLight,
    secondaryFixedDim: Color(0xFFBAE6FD),
    onSecondaryFixed: yoBlueDark,
    onSecondaryFixedVariant: Color(0xFF0284C7),
    tertiary: Color(0xFFD97706),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFEF3C7),
    onTertiaryContainer: Color(0xFF92400E),
    tertiaryFixed: Color(0xFFFEF3C7),
    tertiaryFixedDim: Color(0xFFFDE68A),
    onTertiaryFixed: Color(0xFF92400E),
    onTertiaryFixedVariant: Color(0xFFD97706),
    surface: surface,
    onSurface: textPrimary,
    onSurfaceVariant: textSecondary,
    surfaceDim: Color(0xFFF1F5F9),
    surfaceBright: surface,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF8FAFC),
    surfaceContainer: background,
    surfaceContainerHigh: Color(0xFFF1F5F9),
    surfaceContainerHighest: Color(0xFFE2E8F0),
    surfaceTint: yoPurple,
    error: error,
    onError: Colors.white,
    errorContainer: errorContainerLight,
    onErrorContainer: onErrorContainerLight,
    outline: divider,
    outlineVariant: Color(0xFFCBD5E1),
    shadow: Color(0x140F172A),
    scrim: Colors.black,
    inverseSurface: Color(0xFF0F172A),
    onInverseSurface: Color(0xFFF8FAFC),
    inversePrimary: Color(0xFFA78BFA),
  );

  // ===========================================================================
  // DARK COLOR SCHEMES (Accurate On-Colors & High Contrast)
  // ===========================================================================

  // 1. Doctor Dark Scheme
  static const ColorScheme doctorDarkColorScheme = ColorScheme.dark(
    primary: Color(0xFF38BDF8),
    onPrimary: Color(0xFF082F49), // Deep Navy for sharp readability on Cyan
    primaryContainer: Color(0xFF0C4A6E),
    onPrimaryContainer: Color(0xFFBAE6FD), // Soft Tinted Cyan on Deep Container
    primaryFixed: Color(0xFF0284C7),
    primaryFixedDim: Color(0xFF0369A1),
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: Color(0xFFBAE6FD),
    secondary: Color(0xFF34D399),
    onSecondary: Color(0xFF064E3B), // Deep Forest on Emerald
    secondaryContainer: Color(0xFF065F46),
    onSecondaryContainer: Color(0xFFA7F3D0),
    secondaryFixed: Color(0xFF059669),
    secondaryFixedDim: Color(0xFF047857),
    onSecondaryFixed: Colors.white,
    onSecondaryFixedVariant: Color(0xFFA7F3D0),
    tertiary: Color(0xFF22D3EE),
    onTertiary: Color(0xFF083344),
    tertiaryContainer: Color(0xFF164E63),
    onTertiaryContainer: Color(0xFFCFFAFE),
    tertiaryFixed: Color(0xFF0891B2),
    tertiaryFixedDim: Color(0xFF155E75),
    onTertiaryFixed: Colors.white,
    onTertiaryFixedVariant: Color(0xFFCFFAFE),
    surface: doctorDarkSurface,
    onSurface: darkTextPrimary,
    onSurfaceVariant: darkTextSecondary,
    surfaceDim: doctorDarkBackground,
    surfaceBright: doctorDarkSurfaceHigh,
    surfaceContainerLowest: doctorDarkBackground,
    surfaceContainerLow: doctorDarkSurface,
    surfaceContainer: doctorDarkSurfaceContainer,
    surfaceContainerHigh: doctorDarkSurfaceHigh,
    surfaceContainerHighest: doctorDarkSurfaceHighest,
    surfaceTint: Color(0xFF38BDF8),
    error: errorDark,
    onError: Color(0xFF450A0A),
    errorContainer: errorContainerDark,
    onErrorContainer: onErrorContainerDark,
    outline: doctorDarkDivider,
    outlineVariant: Color(0xFF2E4663),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF8FAFC),
    onInverseSurface: Color(0xFF0F172A),
    inversePrimary: yoBlue,
  );

  // 2. Patient Dark Scheme
  static const ColorScheme patientDarkColorScheme = ColorScheme.dark(
    primary: Color(0xFF34D399),
    onPrimary: Color(0xFF064E3B), // Deep Forest on Emerald
    primaryContainer: Color(0xFF065F46),
    onPrimaryContainer: Color(0xFFA7F3D0),
    primaryFixed: Color(0xFF059669),
    primaryFixedDim: Color(0xFF047857),
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: Color(0xFFA7F3D0),
    secondary: Color(0xFF38BDF8),
    onSecondary: Color(0xFF082F49), // Deep Navy on Sky
    secondaryContainer: Color(0xFF0C4A6E),
    onSecondaryContainer: Color(0xFFBAE6FD),
    secondaryFixed: Color(0xFF0284C7),
    secondaryFixedDim: Color(0xFF0369A1),
    onSecondaryFixed: Colors.white,
    onSecondaryFixedVariant: Color(0xFFBAE6FD),
    tertiary: Color(0xFF2DD4BF),
    onTertiary: Color(0xFF042F2E),
    tertiaryContainer: Color(0xFF134E4A),
    onTertiaryContainer: Color(0xFFCCFBF1),
    tertiaryFixed: Color(0xFF0D9488),
    tertiaryFixedDim: Color(0xFF115E59),
    onTertiaryFixed: Colors.white,
    onTertiaryFixedVariant: Color(0xFFCCFBF1),
    surface: patientDarkSurface,
    onSurface: darkTextPrimary,
    onSurfaceVariant: darkTextSecondary,
    surfaceDim: patientDarkBackground,
    surfaceBright: patientDarkSurfaceHigh,
    surfaceContainerLowest: patientDarkBackground,
    surfaceContainerLow: patientDarkSurface,
    surfaceContainer: patientDarkSurfaceContainer,
    surfaceContainerHigh: patientDarkSurfaceHigh,
    surfaceContainerHighest: patientDarkSurfaceHighest,
    surfaceTint: Color(0xFF34D399),
    error: errorDark,
    onError: Color(0xFF450A0A),
    errorContainer: errorContainerDark,
    onErrorContainer: onErrorContainerDark,
    outline: patientDarkDivider,
    outlineVariant: Color(0xFF2C5240),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF8FAFC),
    onInverseSurface: Color(0xFF0F172A),
    inversePrimary: yoGreen,
  );

  // 3. Admin Dark Scheme
  static const ColorScheme adminDarkColorScheme = ColorScheme.dark(
    primary: Color(0xFFA78BFA),
    onPrimary: Color(0xFF2E1065), // Deep Purple on Violet
    primaryContainer: Color(0xFF5B21B6),
    onPrimaryContainer: Color(0xFFEDE9FE),
    primaryFixed: Color(0xFF7C3AED),
    primaryFixedDim: Color(0xFF5B21B6),
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: Color(0xFFDDD6FE),
    secondary: Color(0xFF38BDF8),
    onSecondary: Color(0xFF082F49),
    secondaryContainer: Color(0xFF0C4A6E),
    onSecondaryContainer: Color(0xFFBAE6FD),
    secondaryFixed: Color(0xFF0284C7),
    secondaryFixedDim: Color(0xFF0369A1),
    onSecondaryFixed: Colors.white,
    onSecondaryFixedVariant: Color(0xFFBAE6FD),
    tertiary: Color(0xFFFBBF24),
    onTertiary: Color(0xFF451A03),
    tertiaryContainer: Color(0xFF78350F),
    onTertiaryContainer: Color(0xFFFEF3C7),
    tertiaryFixed: Color(0xFFD97706),
    tertiaryFixedDim: Color(0xFF92400E),
    onTertiaryFixed: Colors.white,
    onTertiaryFixedVariant: Color(0xFFFEF3C7),
    surface: adminDarkSurface,
    onSurface: darkTextPrimary,
    onSurfaceVariant: darkTextSecondary,
    surfaceDim: adminDarkBackground,
    surfaceBright: adminDarkSurfaceHigh,
    surfaceContainerLowest: adminDarkBackground,
    surfaceContainerLow: adminDarkSurface,
    surfaceContainer: adminDarkSurfaceContainer,
    surfaceContainerHigh: adminDarkSurfaceHigh,
    surfaceContainerHighest: adminDarkSurfaceHighest,
    surfaceTint: Color(0xFFA78BFA),
    error: errorDark,
    onError: Color(0xFF450A0A),
    errorContainer: errorContainerDark,
    onErrorContainer: onErrorContainerDark,
    outline: adminDarkDivider,
    outlineVariant: Color(0xFF4B3970),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF8FAFC),
    onInverseSurface: Color(0xFF0F172A),
    inversePrimary: yoPurple,
  );
}