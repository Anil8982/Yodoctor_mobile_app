// import 'package:flutter/material.dart';
//
// class AppColors {
//   AppColors._();
//
//   // ===========================================================================
//   // BRAND COLORS (Restored from Original Commented Spec)
//   // ===========================================================================
//
//   // Doctor (Original YoBlue)
//   static const Color yoBlue = Color(0xFF1565C0);
//   static const Color yoBlueDark = Color(0xFF0D47A1);
//   static const Color yoBlueLight = Color(0xFFE3F0FF);
//
//   // Patient (Original YoGreen)
//   static const Color yoGreen = Color(0xFF2E7D32);
//   static const Color yoGreenDark = Color(0xFF1B5E20);
//   static const Color yoGreenLight = Color(0xFFE8F5E9);
//
//   // Admin (Original YoPurple)
//   static const Color yoPurple = Color(0xFF8A63B5);
//   static const Color yoPurpleDark = Color(0xFF6F42A6);
//   static const Color yoPurpleLight = Color(0xFFEDE3F8);
//
//   // ===========================================================================
//   // STATUS TOKENS (Solid Accents)
//   // ===========================================================================
//
//   static const Color success = Color(0xFF10B981);
//   static const Color warning = Color(0xFFF59E0B);
//   static const Color error = Color(0xFFEF4444);
//   static const Color info = Color(0xFF0EA5E9);
//   static const Color pending = Color(0xFFF97316);
//   static const Color cancelled = Color(0xFF64748B);
//   static const Color active = Color(0xFF10B981);
//   static const Color inactive = Color(0xFF94A3B8);
//
//   // Dark Status Accents
//   static const Color successDark = Color(0xFF34D399);
//   static const Color warningDark = Color(0xFFFBBF24);
//   static const Color errorDark = Color(0xFFF87171);
//   static const Color infoDark = Color(0xFF38BDF8);
//   static const Color pendingDark = Color(0xFFFB923C);
//   static const Color cancelledDark = Color(0xFF94A3B8);
//   static const Color activeDark = Color(0xFF34D399);
//   static const Color inactiveDark = Color(0xFF64748B);
//
//   // ===========================================================================
//   // STATUS BADGES & ON-STATUS TOKENS (Light vs Dark Adaptive)
//   // ===========================================================================
//
//   // --- Light Mode Status Badges ---
//   static const Color successContainerLight = Color(0xFFECFDF5);
//   static const Color onSuccessContainerLight = Color(0xFF065F46);
//
//   static const Color warningContainerLight = Color(0xFFFFFBEB);
//   static const Color onWarningContainerLight = Color(0xFF92400E);
//
//   static const Color errorContainerLight = Color(0xFFFEF2F2);
//   static const Color onErrorContainerLight = Color(0xFF991B1B);
//
//   static const Color infoContainerLight = Color(0xFFF0F9FF);
//   static const Color onInfoContainerLight = Color(0xFF075985);
//
//   static const Color pendingContainerLight = Color(0xFFFFF7ED);
//   static const Color onPendingContainerLight = Color(0xFF9A3412);
//
//   static const Color cancelledContainerLight = Color(0xFFF8FAFC);
//   static const Color onCancelledContainerLight = Color(0xFF475569);
//
//   // --- Dark Mode Status Badges (High Contrast, No Eye-Strain) ---
//   static const Color successContainerDark = Color(0xFF064E3B);
//   static const Color onSuccessContainerDark = Color(0xFFA7F3D0);
//
//   static const Color warningContainerDark = Color(0xFF451A03);
//   static const Color onWarningContainerDark = Color(0xFFFDE68A);
//
//   static const Color errorContainerDark = Color(0xFF450A0A);
//   static const Color onErrorContainerDark = Color(0xFFFECACA);
//
//   static const Color infoContainerDark = Color(0xFF082F49);
//   static const Color onInfoContainerDark = Color(0xFFBAE6FD);
//
//   static const Color pendingContainerDark = Color(0xFF431407);
//   static const Color onPendingContainerDark = Color(0xFFFED7AA);
//
//   static const Color cancelledContainerDark = Color(0xFF1E293B);
//   static const Color onCancelledContainerDark = Color(0xFFCBD5E1);
//
//   // Legacy aliases
//   static const Color onSuccess = onSuccessContainerLight;
//   static const Color onWarning = onWarningContainerLight;
//   static const Color onError = onErrorContainerLight;
//   static const Color onInfo = onInfoContainerLight;
//   static const Color onPending = onPendingContainerLight;
//   static const Color onCancelled = onCancelledContainerLight;
//   static const Color onActive = onSuccessContainerLight;
//   static const Color onInactive = onCancelledContainerLight;
//
//   // ===========================================================================
//   // TYPOGRAPHY BASE TOKENS
//   // ===========================================================================
//
//   static const Color textPrimary = Color(0xFF0F172A);
//   static const Color textSecondary = Color(0xFF475569);
//   static const Color textHint = Color(0xFF94A3B8);
//
//   static const Color darkTextPrimary = Color(0xFFF1F5F9);
//   static const Color darkTextSecondary = Color(0xFF94A3B8);
//   static const Color darkTextHint = Color(0xFF64748B);
//
//   // ===========================================================================
//   // LIGHT NEUTRALS & INPUTS
//   // ===========================================================================
//
//   static const Color background = Color(0xFFF8FAFC);
//   static const Color surface = Color(0xFFFFFFFF);
//   static const Color divider = Color(0xFFE2E8F0);
//
//   static const Color inputFill = Color(0xFFF1F5F9);
//   static const Color inputFillGreen = Color(0xFFECFDF5);
//
//   // ===========================================================================
//   // DARK THEME OBSIDIAN FOUNDATION
//   // ===========================================================================
//
//   // 1. Doctor Dark (Deep Ocean Obsidian)
//   static const Color doctorDarkBackground = Color(0xFF0B111A);
//   static const Color doctorDarkSurface = Color(0xFF111A26);
//   static const Color doctorDarkSurfaceContainer = Color(0xFF172333);
//   static const Color doctorDarkSurfaceHigh = Color(0xFF1F2F44);
//   static const Color doctorDarkSurfaceHighest = Color(0xFF283D56);
//   static const Color doctorDarkDivider = Color(0xFF22354D);
//
//   // 2. Patient Dark (Forest Pine Obsidian)
//   static const Color patientDarkBackground = Color(0xFF0B1410);
//   static const Color patientDarkSurface = Color(0xFF111E18);
//   static const Color patientDarkSurfaceContainer = Color(0xFF172921);
//   static const Color patientDarkSurfaceHigh = Color(0xFF1F372C);
//   static const Color patientDarkSurfaceHighest = Color(0xFF29473A);
//   static const Color patientDarkDivider = Color(0xFF223E31);
//
//   // 3. Admin Dark (Midnight Amethyst Obsidian)
//   static const Color adminDarkBackground = Color(0xFF100C1A);
//   static const Color adminDarkSurface = Color(0xFF171224);
//   static const Color adminDarkSurfaceContainer = Color(0xFF211A33);
//   static const Color adminDarkSurfaceHigh = Color(0xFF2C2344);
//   static const Color adminDarkSurfaceHighest = Color(0xFF3A2E59);
//   static const Color adminDarkDivider = Color(0xFF33274F);
//
//   // ===========================================================================
//   // LIGHT COLOR SCHEMES
//   // ===========================================================================
//
//   // 1. Doctor Light Scheme
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
//     tertiary: Color(0xFF0891B2),
//     onTertiary: Colors.white,
//     tertiaryContainer: Color(0xFFCFFAFE),
//     onTertiaryContainer: Color(0xFF155E75),
//     tertiaryFixed: Color(0xFFCFFAFE),
//     tertiaryFixedDim: Color(0xFFA5F3FC),
//     onTertiaryFixed: Color(0xFF155E75),
//     onTertiaryFixedVariant: Color(0xFF0891B2),
//     surface: surface,
//     onSurface: textPrimary,
//     onSurfaceVariant: textSecondary,
//     surfaceDim: Color(0xFFF1F5F9),
//     surfaceBright: surface,
//     surfaceContainerLowest: Colors.white,
//     surfaceContainerLow: Color(0xFFF8FAFC),
//     surfaceContainer: background,
//     surfaceContainerHigh: Color(0xFFF1F5F9),
//     surfaceContainerHighest: Color(0xFFE2E8F0),
//     surfaceTint: yoBlue,
//     error: error,
//     onError: Colors.white,
//     errorContainer: errorContainerLight,
//     onErrorContainer: onErrorContainerLight,
//     outline: divider,
//     outlineVariant: Color(0xFFCBD5E1),
//     shadow: Color(0x140F172A),
//     scrim: Colors.black,
//     inverseSurface: Color(0xFF0F172A),
//     onInverseSurface: Color(0xFFF8FAFC),
//     inversePrimary: Color(0xFF90CAF9),
//   );
//
//   // 2. Patient Light Scheme
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
//     tertiary: Color(0xFF0D9488),
//     onTertiary: Colors.white,
//     tertiaryContainer: Color(0xFFCCFBF1),
//     onTertiaryContainer: Color(0xFF115E59),
//     tertiaryFixed: Color(0xFFCCFBF1),
//     tertiaryFixedDim: Color(0xFF99F6E4),
//     onTertiaryFixed: Color(0xFF115E59),
//     onTertiaryFixedVariant: Color(0xFF0D9488),
//     surface: surface,
//     onSurface: textPrimary,
//     onSurfaceVariant: textSecondary,
//     surfaceDim: Color(0xFFF1F5F9),
//     surfaceBright: surface,
//     surfaceContainerLowest: Colors.white,
//     surfaceContainerLow: Color(0xFFF8FAFC),
//     surfaceContainer: background,
//     surfaceContainerHigh: Color(0xFFF1F5F9),
//     surfaceContainerHighest: Color(0xFFE2E8F0),
//     surfaceTint: yoGreen,
//     error: error,
//     onError: Colors.white,
//     errorContainer: errorContainerLight,
//     onErrorContainer: onErrorContainerLight,
//     outline: divider,
//     outlineVariant: Color(0xFFCBD5E1),
//     shadow: Color(0x140F172A),
//     scrim: Colors.black,
//     inverseSurface: Color(0xFF0F172A),
//     onInverseSurface: Color(0xFFF8FAFC),
//     inversePrimary: Color(0xFFA5D6A7),
//   );
//
//   // 3. Admin Light Scheme
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
//     secondaryContainer: yoBlueLight,
//     onSecondaryContainer: yoBlueDark,
//     secondaryFixed: yoBlueLight,
//     secondaryFixedDim: Color(0xFF90CAF9),
//     onSecondaryFixed: yoBlueDark,
//     onSecondaryFixedVariant: Color(0xFF1976D2),
//     tertiary: Color(0xFFD97706),
//     onTertiary: Colors.white,
//     tertiaryContainer: Color(0xFFFEF3C7),
//     onTertiaryContainer: Color(0xFF92400E),
//     tertiaryFixed: Color(0xFFFEF3C7),
//     tertiaryFixedDim: Color(0xFFFDE68A),
//     onTertiaryFixed: Color(0xFF92400E),
//     onTertiaryFixedVariant: Color(0xFFD97706),
//     surface: surface,
//     onSurface: textPrimary,
//     onSurfaceVariant: textSecondary,
//     surfaceDim: Color(0xFFF1F5F9),
//     surfaceBright: surface,
//     surfaceContainerLowest: Colors.white,
//     surfaceContainerLow: Color(0xFFF8FAFC),
//     surfaceContainer: background,
//     surfaceContainerHigh: Color(0xFFF1F5F9),
//     surfaceContainerHighest: Color(0xFFE2E8F0),
//     surfaceTint: yoPurple,
//     error: error,
//     onError: Colors.white,
//     errorContainer: errorContainerLight,
//     onErrorContainer: onErrorContainerLight,
//     outline: divider,
//     outlineVariant: Color(0xFFCBD5E1),
//     shadow: Color(0x140F172A),
//     scrim: Colors.black,
//     inverseSurface: Color(0xFF0F172A),
//     onInverseSurface: Color(0xFFF8FAFC),
//     inversePrimary: Color(0xFFA5D6A7),
//   );
//
//   // ===========================================================================
//   // DARK COLOR SCHEMES (Original Primary/Secondary with Obsidian Surfaces)
//   // ===========================================================================
//
//   // 1. Doctor Dark Scheme
//   static const ColorScheme doctorDarkColorScheme = ColorScheme.dark(
//     primary: Color(0xFF1E88E5), // Original Dark Primary
//     onPrimary: Colors.white,
//     primaryContainer: Color(0xFF0D47A1), // Original yoBlueDark
//     onPrimaryContainer: Color(0xFF90CAF9),
//     primaryFixed: Color(0xFF42A5F5),
//     primaryFixedDim: Color(0xFF1976D2),
//     onPrimaryFixed: Colors.white,
//     onPrimaryFixedVariant: Color(0xFF64B5F6),
//     secondary: Color(0xFF43A047), // Original Dark Secondary
//     onSecondary: Colors.white,
//     secondaryContainer: Color(0xFF1B5E20), // Original yoGreenDark
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
//     surfaceContainerLowest: doctorDarkBackground,
//     surfaceContainerLow: doctorDarkSurface,
//     surfaceContainer: doctorDarkSurfaceContainer,
//     surfaceContainerHigh: doctorDarkSurfaceHigh,
//     surfaceContainerHighest: doctorDarkSurfaceHighest,
//     surfaceTint: Color(0xFF1E88E5),
//     error: errorDark,
//     onError: Color(0xFF450A0A),
//     errorContainer: errorContainerDark,
//     onErrorContainer: onErrorContainerDark,
//     outline: doctorDarkDivider,
//     outlineVariant: Color(0xFF22354D),
//     shadow: Colors.black,
//     scrim: Colors.black,
//     inverseSurface: Color(0xFFF8FAFC),
//     onInverseSurface: Color(0xFF0F172A),
//     inversePrimary: yoBlue,
//   );
//
//   // 2. Patient Dark Scheme
//   static const ColorScheme patientDarkColorScheme = ColorScheme.dark(
//     primary: Color(0xFF43A047), // Original Dark Primary
//     onPrimary: Colors.white,
//     primaryContainer: Color(0xFF1B5E20), // Original yoGreenDark
//     onPrimaryContainer: Color(0xFFA5D6A7),
//     primaryFixed: Color(0xFF66BB6A),
//     primaryFixedDim: Color(0xFF388E3C),
//     onPrimaryFixed: Colors.white,
//     onPrimaryFixedVariant: Color(0xFF81C784),
//     secondary: Color(0xFF1E88E5), // Original Dark Secondary
//     onSecondary: Colors.white,
//     secondaryContainer: Color(0xFF0D47A1), // Original yoBlueDark
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
//     surfaceContainerLowest: patientDarkBackground,
//     surfaceContainerLow: patientDarkSurface,
//     surfaceContainer: patientDarkSurfaceContainer,
//     surfaceContainerHigh: patientDarkSurfaceHigh,
//     surfaceContainerHighest: patientDarkSurfaceHighest,
//     surfaceTint: Color(0xFF43A047),
//     error: errorDark,
//     onError: Color(0xFF450A0A),
//     errorContainer: errorContainerDark,
//     onErrorContainer: onErrorContainerDark,
//     outline: patientDarkDivider,
//     outlineVariant: Color(0xFF223E31),
//     shadow: Colors.black,
//     scrim: Colors.black,
//     inverseSurface: Color(0xFFF8FAFC),
//     onInverseSurface: Color(0xFF0F172A),
//     inversePrimary: yoGreen,
//   );
//
//   // 3. Admin Dark Scheme
//   static const ColorScheme adminDarkColorScheme = ColorScheme.dark(
//     primary: Color(0xFF8E24AA), // Original Dark Primary
//     onPrimary: Colors.white,
//     primaryContainer: Color(0xFF4A148C), // Original yoPurpleDark
//     onPrimaryContainer: Color(0xFFCE93D8),
//     primaryFixed: Color(0xFFAB47BC),
//     primaryFixedDim: Color(0xFF7B1FA2),
//     onPrimaryFixed: Colors.white,
//     onPrimaryFixedVariant: Color(0xFFBA68C8),
//     secondary: Color(0xFF1E88E5), // Original Dark Secondary
//     onSecondary: Colors.white,
//     secondaryContainer: Color(0xFF0D47A1), // Original yoBlueDark
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
//     surfaceContainerLowest: adminDarkBackground,
//     surfaceContainerLow: adminDarkSurface,
//     surfaceContainer: adminDarkSurfaceContainer,
//     surfaceContainerHigh: adminDarkSurfaceHigh,
//     surfaceContainerHighest: adminDarkSurfaceHighest,
//     surfaceTint: Color(0xFF8E24AA),
//     error: errorDark,
//     onError: Color(0xFF450A0A),
//     errorContainer: errorContainerDark,
//     onErrorContainer: onErrorContainerDark,
//     outline: adminDarkDivider,
//     outlineVariant: Color(0xFF33274F),
//     shadow: Colors.black,
//     scrim: Colors.black,
//     inverseSurface: Color(0xFFF8FAFC),
//     onInverseSurface: Color(0xFF0F172A),
//     inversePrimary: yoPurple,
//   );
// }


import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===========================================================================
  // BRAND COLORS (Restored from Original Commented Spec)
  // ===========================================================================

  // Doctor (Original YoBlue)
  static const Color yoBlue = Color(0xFF1565C0);
  static const Color yoBlueDark = Color(0xFF0D47A1);
  static const Color yoBlueLight = Color(0xFFE3F0FF);

  // Patient (Original YoGreen - Retained as requested)
  static const Color yoGreen = Color(0xFF2E7D32);
  static const Color yoGreenDark = Color(0xFF1B5E20);
  static const Color yoGreenLight = Color(0xFFE8F5E9);

  // Patient New Fresh Digital Health Tokens
  static const Color patientPrimaryTeal = Color(0xFF087E8B);
  static const Color patientTurquoise = Color(0xFF46D6C4);
  static const Color patientPaleAqua = Color(0xFFE4FBF6);
  static const Color patientText = Color(0xFF17343A);
  static const Color patientSecondaryText = Color(0xFF52666D);
  static const Color patientBorderLight = Color(0xFFDCE7EA);

  // Patient Dark Theme Tokens
  static const Color patientDarkBg = Color(0xFF050D10);
  static const Color patientDarkCard = Color(0xFF101D22);
  static const Color patientDarkElevatedSurface = Color(0xFF16272D);
  static const Color patientDarkPrimaryText = Color(0xFFEAF7F7);
  static const Color patientDarkSecondaryText = Color(0xA5BEC0);
  static const Color patientDarkBorder = Color(0xFF243940);

  // Admin (Original YoPurple)
  static const Color yoPurple = Color(0xFF8A63B5);
  static const Color yoPurpleDark = Color(0xFF6F42A6);
  static const Color yoPurpleLight = Color(0xFFEDE3F8);

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

  // Legacy aliases
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

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);

  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextHint = Color(0xFF64748B);

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

  // 2. Patient Dark (Deep Midnight Teal)
  static const Color patientDarkBackground = patientDarkBg;
  static const Color patientDarkSurface = patientDarkCard;
  static const Color patientDarkSurfaceContainer = patientDarkElevatedSurface;
  static const Color patientDarkSurfaceHigh = Color(0xFF1C323B);
  static const Color patientDarkSurfaceHighest = Color(0xFF243F4A);
  static const Color patientDarkDivider = patientDarkBorder;

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
    inversePrimary: Color(0xFF90CAF9),
  );

  // 2. Patient Light Scheme (Updated to Fresh Digital Health)
  static const ColorScheme patientColorScheme = ColorScheme.light(
    primary: patientPrimaryTeal,
    onPrimary: Colors.white,
    primaryContainer: patientPaleAqua,
    onPrimaryContainer: patientPrimaryTeal,
    primaryFixed: patientPaleAqua,
    primaryFixedDim: patientTurquoise,
    onPrimaryFixed: patientText,
    onPrimaryFixedVariant: patientPrimaryTeal,
    secondary: patientTurquoise,
    onSecondary: patientText,
    secondaryContainer: patientPaleAqua,
    onSecondaryContainer: patientPrimaryTeal,
    secondaryFixed: patientPaleAqua,
    secondaryFixedDim: patientTurquoise,
    onSecondaryFixed: patientText,
    onSecondaryFixedVariant: patientPrimaryTeal,
    tertiary: patientTurquoise,
    onTertiary: patientText,
    tertiaryContainer: patientPaleAqua,
    onTertiaryContainer: patientPrimaryTeal,
    tertiaryFixed: patientPaleAqua,
    tertiaryFixedDim: patientTurquoise,
    onTertiaryFixed: patientText,
    onTertiaryFixedVariant: patientPrimaryTeal,
    surface: Colors.white,
    onSurface: patientText,
    onSurfaceVariant: patientSecondaryText,
    surfaceDim: Color(0xFFEEF3F5),
    surfaceBright: Colors.white,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF7FAFC),
    surfaceContainer: Color(0xFFF7FAFC), // Main background
    surfaceContainerHigh: Color(0xFFEEF4F6),
    surfaceContainerHighest: Color(0xFFE4EBEE),
    surfaceTint: patientPrimaryTeal,
    error: error,
    onError: Colors.white,
    errorContainer: errorContainerLight,
    onErrorContainer: onErrorContainerLight,
    outline: patientBorderLight,
    outlineVariant: Color(0xFFCBD8DC),
    shadow: Color(0x1417343A),
    scrim: Colors.black,
    inverseSurface: patientText,
    onInverseSurface: Color(0xFFF7FAFC),
    inversePrimary: patientTurquoise,
  );

  // 3. Admin Light Scheme
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
    secondaryContainer: yoBlueLight,
    onSecondaryContainer: yoBlueDark,
    secondaryFixed: yoBlueLight,
    secondaryFixedDim: Color(0xFF90CAF9),
    onSecondaryFixed: yoBlueDark,
    onSecondaryFixedVariant: Color(0xFF1976D2),
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
    inversePrimary: Color(0xFFA5D6A7),
  );

  // ===========================================================================
  // DARK COLOR SCHEMES (Original Primary/Secondary with Obsidian Surfaces)
  // ===========================================================================

  // 1. Doctor Dark Scheme
  static const ColorScheme doctorDarkColorScheme = ColorScheme.dark(
    primary: Color(0xFF1E88E5), // Original Dark Primary
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF0D47A1), // Original yoBlueDark
    onPrimaryContainer: Color(0xFF90CAF9),
    primaryFixed: Color(0xFF42A5F5),
    primaryFixedDim: Color(0xFF1976D2),
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: Color(0xFF64B5F6),
    secondary: Color(0xFF43A047), // Original Dark Secondary
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF1B5E20), // Original yoGreenDark
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
    surfaceContainerLowest: doctorDarkBackground,
    surfaceContainerLow: doctorDarkSurface,
    surfaceContainer: doctorDarkSurfaceContainer,
    surfaceContainerHigh: doctorDarkSurfaceHigh,
    surfaceContainerHighest: doctorDarkSurfaceHighest,
    surfaceTint: Color(0xFF1E88E5),
    error: errorDark,
    onError: Color(0xFF450A0A),
    errorContainer: errorContainerDark,
    onErrorContainer: onErrorContainerDark,
    outline: doctorDarkDivider,
    outlineVariant: Color(0xFF22354D),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF8FAFC),
    onInverseSurface: Color(0xFF0F172A),
    inversePrimary: yoBlue,
  );

  // 2. Patient Dark Scheme (Updated to Deep Midnight Teal)
  static const ColorScheme patientDarkColorScheme = ColorScheme.dark(
    primary: patientPrimaryTeal,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF04484F),
    onPrimaryContainer: patientTurquoise,
    primaryFixed: patientTurquoise,
    primaryFixedDim: patientPrimaryTeal,
    onPrimaryFixed: patientDarkBg,
    onPrimaryFixedVariant: patientTurquoise,
    secondary: patientTurquoise,
    onSecondary: patientDarkBg,
    secondaryContainer: Color(0xFF0B2E33),
    onSecondaryContainer: patientTurquoise,
    secondaryFixed: patientTurquoise,
    secondaryFixedDim: patientPrimaryTeal,
    onSecondaryFixed: patientDarkBg,
    onSecondaryFixedVariant: patientTurquoise,
    tertiary: patientTurquoise,
    onTertiary: patientDarkBg,
    tertiaryContainer: Color(0xFF0B2E33),
    onTertiaryContainer: patientTurquoise,
    tertiaryFixed: patientTurquoise,
    tertiaryFixedDim: patientPrimaryTeal,
    onTertiaryFixed: patientDarkBg,
    onTertiaryFixedVariant: patientTurquoise,
    surface: patientDarkCard,
    onSurface: patientDarkPrimaryText,
    onSurfaceVariant: patientDarkSecondaryText,
    surfaceDim: patientDarkBg,
    surfaceBright: patientDarkElevatedSurface,
    surfaceContainerLowest: patientDarkBg,
    surfaceContainerLow: patientDarkCard,
    surfaceContainer: patientDarkElevatedSurface,
    surfaceContainerHigh: Color(0xFF1C323B),
    surfaceContainerHighest: Color(0xFF243F4A),
    surfaceTint: patientPrimaryTeal,
    error: errorDark,
    onError: Color(0xFF450A0A),
    errorContainer: errorContainerDark,
    onErrorContainer: onErrorContainerDark,
    outline: patientDarkBorder,
    outlineVariant: Color(0xFF1A2D33),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFEAF7F7),
    onInverseSurface: patientDarkBg,
    inversePrimary: patientPrimaryTeal,
  );

  // 3. Admin Dark Scheme
  static const ColorScheme adminDarkColorScheme = ColorScheme.dark(
    primary: Color(0xFF8E24AA), // Original Dark Primary
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF4A148C), // Original yoPurpleDark
    onPrimaryContainer: Color(0xFFCE93D8),
    primaryFixed: Color(0xFFAB47BC),
    primaryFixedDim: Color(0xFF7B1FA2),
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: Color(0xFFBA68C8),
    secondary: Color(0xFF1E88E5), // Original Dark Secondary
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF0D47A1), // Original yoBlueDark
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
    surfaceContainerLowest: adminDarkBackground,
    surfaceContainerLow: adminDarkSurface,
    surfaceContainer: adminDarkSurfaceContainer,
    surfaceContainerHigh: adminDarkSurfaceHigh,
    surfaceContainerHighest: adminDarkSurfaceHighest,
    surfaceTint: Color(0xFF8E24AA),
    error: errorDark,
    onError: Color(0xFF450A0A),
    errorContainer: errorContainerDark,
    onErrorContainer: onErrorContainerDark,
    outline: adminDarkDivider,
    outlineVariant: Color(0xFF33274F),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF8FAFC),
    onInverseSurface: Color(0xFF0F172A),
    inversePrimary: yoPurple,
  );
}