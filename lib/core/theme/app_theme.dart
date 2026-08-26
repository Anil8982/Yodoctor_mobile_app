// import 'package:chroma_kit/chroma_kit.dart';
// import 'package:flutter/material.dart';
// import 'app_colors.dart';
//
// class AppTheme {
//   AppTheme._();
//
//   // Gradients Forwarding
//   static LinearGradient get doctorGradient => AppColors.doctorGradient;
//   static LinearGradient get patientGradient => AppColors.patientGradient;
//   static LinearGradient get adminGradient => AppColors.adminGradient;
//   static LinearGradient get brandGradient => AppColors.brandGradient;
//   static LinearGradient get backgroundGradient => AppColors.backgroundGradient;
//
//   // Exact Brand Colors Forwarding
//   static Color get yoBlue => AppColors.yoBlue;
//   static Color get yoBlueDark => AppColors.yoBlueDark;
//   static Color get yoBlueLight => AppColors.yoBlueLight;
//
//   static Color get yoGreen => AppColors.yoGreen;
//   static Color get yoGreenDark => AppColors.yoGreenDark;
//   static Color get yoGreenLight => AppColors.yoGreenLight;
//
//   static Color get yoPurple => AppColors.yoPurple;
//   static Color get yoPurpleDark => AppColors.yoPurpleDark;
//   static Color get yoPurpleLight => AppColors.yoPurpleLight;
//
//   // Primary & Secondary Aliases
//   static Color get primary => AppColors.yoBlue;
//   static Color get primaryDark => AppColors.yoBlueDark;
//   static Color get primaryLight => AppColors.yoBlueLight;
//   static Color get secondary => AppColors.yoGreen;
//   static Color get secondaryDark => AppColors.yoGreenDark;
//   static Color get secondaryLight => AppColors.yoGreenLight;
//
//   // Role-Specific Mapping
//   static Color get doctorColor => AppColors.yoBlue;
//   static Color get doctorLight => AppColors.yoBlueLight;
//   static Color get patientColor => AppColors.yoGreen;
//   static Color get patientLight => AppColors.yoGreenLight;
//
//   // Interface Semantics ─────────────────
//   static Color get textPrimary => AppColors.textPrimary;
//   static Color get textSecondary => AppColors.textSecondary;
//   static Color get textHint => AppColors.textHint;
//
//   static Color get background => AppColors.background;
//   static Color get surface => AppColors.surface;
//   static Color get divider => AppColors.divider;
//
//   static Color get inputFill => AppColors.inputFill;
//   static Color get inputFillGreen => AppColors.inputFillGreen;
//
//   // ── Adaptive Status Colors ───────────────────────
//
//   static bool _isDark(BuildContext context) {
//     return Theme.of(context).brightness == Brightness.dark;
//   }
//
//   static Color success(BuildContext context) =>
//       _isDark(context) ? AppColors.successDark : AppColors.success;
//
//   static Color warning(BuildContext context) =>
//       _isDark(context) ? AppColors.warningDark : AppColors.warning;
//
//   static Color error(BuildContext context) =>
//       _isDark(context) ? AppColors.errorDark : AppColors.error;
//
//   static Color info(BuildContext context) =>
//       _isDark(context) ? AppColors.infoDark : AppColors.info;
//
//   static Color pending(BuildContext context) =>
//       _isDark(context) ? AppColors.pendingDark : AppColors.pending;
//
//   static Color cancelled(BuildContext context) =>
//       _isDark(context) ? AppColors.cancelledDark : AppColors.cancelled;
//
//   static Color active(BuildContext context) =>
//       _isDark(context) ? AppColors.activeDark : AppColors.active;
//
//   static Color inactive(BuildContext context) =>
//       _isDark(context) ? AppColors.inactiveDark : AppColors.inactive;
//
//   // ── 🩺 1. Doctor Production ThemeData ─────────────────────
//   static ThemeData get doctorTheme {
//     return _buildTheme(
//       colorScheme: AppColors.doctorColorScheme,
//       gradient: AppColors.doctorGradient,
//     );
//   }
//
//   // ── 👤 2. Patient Production ThemeData ─────────────────────
//   static ThemeData get patientTheme {
//     return _buildTheme(
//       colorScheme: AppColors.patientColorScheme,
//       gradient: AppColors.patientGradient,
//     );
//   }
//
//   // ── 🛠️  3. Admin Production ThemeData ─────────────────────
//   static ThemeData get adminTheme {
//     return _buildTheme(
//       colorScheme: AppColors.adminColorScheme,
//       gradient: AppColors.adminGradient,
//     );
//   }
//
//   // ── 🏗️ Core Theme Spec Factory ────────────────────────────
//   static ThemeData _buildTheme({
//     required ColorScheme colorScheme,
//     required LinearGradient gradient,
//   }) {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//       colorScheme: colorScheme,
//       scaffoldBackgroundColor: colorScheme.surfaceContainer,
//       textTheme: _textTheme,
//
//       appBarTheme: AppBarTheme(
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         backgroundColor: colorScheme.primary,
//         foregroundColor: colorScheme.onPrimary,
//         centerTitle: false,
//         // flexibleSpace: _appBarGradient(gradient),
//       ),
//
//       cardTheme: CardThemeData(
//         color: colorScheme.surface,
//         elevation: 2,
//         shadowColor: Colors.black.transparency( 0.05),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(24)),
//         ),
//       ),
//
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: colorScheme.surface,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         hintStyle: const TextStyle(color: AppColors.textHint),
//         border: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(16)),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(16)),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(16)),
//           borderSide: BorderSide(
//             color: colorScheme.primary,
//             width: 1.4,
//           ),
//         ),
//       ),
//
//       chipTheme: ChipThemeData(
//         backgroundColor: colorScheme.surfaceContainerHigh,
//         selectedColor: colorScheme.primaryContainer,
//         side: BorderSide.none,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//         labelStyle: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w500,
//           color: colorScheme.onSurface,
//         ),
//       ),
//
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: colorScheme.primary,
//           foregroundColor: colorScheme.onPrimary,
//           elevation: 0,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ── 📝 Typography Structure ──────────────────────────────
//   static const TextTheme _textTheme = TextTheme(
//     displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
//     displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
//     displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
//     headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
//     headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
//     headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
//     titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
//     titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
//     titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
//     bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
//     bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
//     bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textHint),
//     labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
//     labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
//     labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textHint),
//   );
// }


import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // Brand colors
  static Color get yoBlue => AppColors.yoBlue;
  static Color get yoBlueDark => AppColors.yoBlueDark;
  static Color get yoBlueLight => AppColors.yoBlueLight;

  static Color get yoGreen => AppColors.yoGreen;
  static Color get yoGreenDark => AppColors.yoGreenDark;
  static Color get yoGreenLight => AppColors.yoGreenLight;

  static Color get yoPurple => AppColors.yoPurple;
  static Color get yoPurpleDark => AppColors.yoPurpleDark;
  static Color get yoPurpleLight => AppColors.yoPurpleLight;

  // Primary and secondary aliases
  static Color get primary => AppColors.yoBlue;
  static Color get primaryDark => AppColors.yoBlueDark;
  static Color get primaryLight => AppColors.yoBlueLight;
  static Color get secondary => AppColors.yoGreen;
  static Color get secondaryDark => AppColors.yoGreenDark;
  static Color get secondaryLight => AppColors.yoGreenLight;

  // Role-specific colors
  static Color get doctorColor => AppColors.yoBlue;
  static Color get doctorLight => AppColors.yoBlueLight;
  static Color get patientColor => AppColors.yoGreen;
  static Color get patientLight => AppColors.yoGreenLight;

  // Interface colors
  static Color get textPrimary => AppColors.textPrimary;
  static Color get textSecondary => AppColors.textSecondary;
  static Color get textHint => AppColors.textHint;

  static Color get background => AppColors.background;
  static Color get surface => AppColors.surface;
  static Color get divider => AppColors.divider;

  static Color get inputFill => AppColors.inputFill;
  static Color get inputFillGreen => AppColors.inputFillGreen;

  // Adaptive status colors
  static bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color success(BuildContext context) =>
      _isDark(context) ? AppColors.successDark : AppColors.success;

  static Color warning(BuildContext context) =>
      _isDark(context) ? AppColors.warningDark : AppColors.warning;

  static Color error(BuildContext context) =>
      _isDark(context) ? AppColors.errorDark : AppColors.error;

  static Color info(BuildContext context) =>
      _isDark(context) ? AppColors.infoDark : AppColors.info;

  static Color pending(BuildContext context) =>
      _isDark(context) ? AppColors.pendingDark : AppColors.pending;

  static Color cancelled(BuildContext context) =>
      _isDark(context) ? AppColors.cancelledDark : AppColors.cancelled;

  static Color active(BuildContext context) =>
      _isDark(context) ? AppColors.activeDark : AppColors.active;

  static Color inactive(BuildContext context) =>
      _isDark(context) ? AppColors.inactiveDark : AppColors.inactive;

  static Color onSuccess(BuildContext context) => AppColors.onSuccess;
  static Color onWarning(BuildContext context) => AppColors.onWarning;
  static Color onError(BuildContext context) => AppColors.onError;
  static Color onInfo(BuildContext context) => AppColors.onInfo;
  static Color onPending(BuildContext context) => AppColors.onPending;
  static Color onCancelled(BuildContext context) => AppColors.onCancelled;
  static Color onActive(BuildContext context) => AppColors.onActive;
  static Color onInactive(BuildContext context) => AppColors.onInactive;

  // Doctor theme
  static ThemeData get doctorTheme {
    return _buildTheme(
      colorScheme: AppColors.doctorColorScheme,
      brightness: Brightness.light,
    );
  }

  // Patient theme
  static ThemeData get patientTheme {
    return _buildTheme(
      colorScheme: AppColors.patientColorScheme,
      brightness: Brightness.light,
    );
  }

  // Admin theme
  static ThemeData get adminTheme {
    return _buildTheme(
      colorScheme: AppColors.adminColorScheme,
      brightness: Brightness.light,
    );
  }

  // Dark themes
  // Doctor dark theme
  static ThemeData get doctorDarkTheme {
    return _buildTheme(
      colorScheme: AppColors.doctorDarkColorScheme,
      brightness: Brightness.dark,
    );
  }

  // Patient dark theme
  static ThemeData get patientDarkTheme {
    return _buildTheme(
      colorScheme: AppColors.patientDarkColorScheme,
      brightness: Brightness.dark,
    );
  }

  // Admin dark theme
  static ThemeData get adminDarkTheme {
    return _buildTheme(
      colorScheme: AppColors.adminDarkColorScheme,
      brightness: Brightness.dark,
    );
  }

  // Theme builder
  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _buildTextTheme(isDark, colorScheme),

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? colorScheme.surfaceContainer : colorScheme.primary,
        foregroundColor: isDark ? colorScheme.onSurface : colorScheme.onPrimary,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHigh,
        elevation: isDark ? 4 : 2,
        shadowColor: isDark ? Colors.black.transparency(0.5) : Colors.black.transparency(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          side: isDark ? BorderSide(color: colorScheme.outlineVariant, width: 1) : BorderSide.none,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: isDark ? AppColors.darkTextHint : AppColors.textHint),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: isDark ? BorderSide(color: colorScheme.outlineVariant) : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: isDark ? BorderSide(color: colorScheme.outlineVariant) : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.4,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: isDark ? colorScheme.surfaceContainerHighest : colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.primaryContainer,
        side: isDark ? BorderSide(color: colorScheme.outlineVariant) : BorderSide.none,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: isDark ? 3 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
    );
  }

  // Typography
  static TextTheme _buildTextTheme(bool isDark, ColorScheme colorScheme) {
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final hintTextColor = isDark ? AppColors.darkTextHint : AppColors.textHint;

    return TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: primaryTextColor),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: primaryTextColor),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: primaryTextColor),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: primaryTextColor),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: primaryTextColor),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: primaryTextColor),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: primaryTextColor),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryTextColor),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primaryTextColor),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primaryTextColor),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: secondaryTextColor),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: hintTextColor),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primaryTextColor),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: secondaryTextColor),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: hintTextColor),
    );
  }
}
