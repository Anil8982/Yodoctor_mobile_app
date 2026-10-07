// import 'package:chroma_kit/chroma_kit.dart';
// import 'package:flutter/material.dart';
// import 'app_colors.dart';
//
// class AppTheme {
//   AppTheme._();
//
//   // Brand colors
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
//   // Primary and secondary aliases
//   static Color get primary => AppColors.yoBlue;
//   static Color get primaryDark => AppColors.yoBlueDark;
//   static Color get primaryLight => AppColors.yoBlueLight;
//   static Color get secondary => AppColors.yoGreen;
//   static Color get secondaryDark => AppColors.yoGreenDark;
//   static Color get secondaryLight => AppColors.yoGreenLight;
//
//   // Role-specific colors
//   static Color get doctorColor => AppColors.yoBlue;
//   static Color get doctorLight => AppColors.yoBlueLight;
//   static Color get patientColor => AppColors.yoGreen;
//   static Color get patientLight => AppColors.yoGreenLight;
//
//   // Interface colors
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
//   // colors- Material Colors
//   static Color get white => Colors.white;
//   static Color get black => Colors.black;
//   static Color get transparent => Colors.transparent;
//   static MaterialColor get grey => Colors.grey;
//   static MaterialColor get green => Colors.green;
//   static MaterialColor get red => Colors.red;
//   static MaterialColor get orange => Colors.orange;
//   static MaterialColor get amber => Colors.amber;
//
//   // Adaptive status colors
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
//   static Color onSuccess(BuildContext context) => AppColors.onSuccess;
//   static Color onWarning(BuildContext context) => AppColors.onWarning;
//   static Color onError(BuildContext context) => AppColors.onError;
//   static Color onInfo(BuildContext context) => AppColors.onInfo;
//   static Color onPending(BuildContext context) => AppColors.onPending;
//   static Color onCancelled(BuildContext context) => AppColors.onCancelled;
//   static Color onActive(BuildContext context) => AppColors.onActive;
//   static Color onInactive(BuildContext context) => AppColors.onInactive;
//
//   // Doctor theme
//   static ThemeData get doctorTheme {
//     return _buildTheme(
//       colorScheme: AppColors.doctorColorScheme,
//       brightness: Brightness.light,
//     );
//   }
//
//   // Patient theme
//   static ThemeData get patientTheme {
//     return _buildTheme(
//       colorScheme: AppColors.patientColorScheme,
//       brightness: Brightness.light,
//     );
//   }
//
//   // Admin theme
//   static ThemeData get adminTheme {
//     return _buildTheme(
//       colorScheme: AppColors.adminColorScheme,
//       brightness: Brightness.light,
//     );
//   }
//
//   // Dark themes
//   // Doctor dark theme
//   static ThemeData get doctorDarkTheme {
//     return _buildTheme(
//       colorScheme: AppColors.doctorDarkColorScheme,
//       brightness: Brightness.dark,
//     );
//   }
//
//   // Patient dark theme
//   static ThemeData get patientDarkTheme {
//     return _buildTheme(
//       colorScheme: AppColors.patientDarkColorScheme,
//       brightness: Brightness.dark,
//     );
//   }
//
//   // Admin dark theme
//   static ThemeData get adminDarkTheme {
//     return _buildTheme(
//       colorScheme: AppColors.adminDarkColorScheme,
//       brightness: Brightness.dark,
//     );
//   }
//
//   // Theme builder
//   static ThemeData _buildTheme({
//     required ColorScheme colorScheme,
//     required Brightness brightness,
//   }) {
//     final isDark = brightness == Brightness.dark;
//
//     return ThemeData(
//       useMaterial3: true,
//       brightness: brightness,
//       colorScheme: colorScheme,
//       scaffoldBackgroundColor: colorScheme.surface,
//       textTheme: _buildTextTheme(isDark, colorScheme),
//
//       appBarTheme: AppBarTheme(
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         backgroundColor: isDark
//             ? colorScheme.surfaceContainer
//             : colorScheme.primary,
//         foregroundColor: isDark ? colorScheme.onSurface : colorScheme.onPrimary,
//         centerTitle: false,
//       ),
//
//       cardTheme: CardThemeData(
//         color: colorScheme.surfaceContainerHigh,
//         elevation: isDark ? 4 : 2,
//         shadowColor: isDark
//             ? Colors.black.transparency(0.5)
//             : Colors.black.transparency(0.05),
//         shape: RoundedRectangleBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(24)),
//           side: isDark
//               ? BorderSide(color: colorScheme.outlineVariant, width: 1)
//               : BorderSide.none,
//         ),
//       ),
//
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: isDark
//             ? colorScheme.surfaceContainerHigh
//             : colorScheme.surface,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//         hintStyle: TextStyle(
//           color: isDark ? AppColors.darkTextHint : AppColors.textHint,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(16)),
//           borderSide: isDark
//               ? BorderSide(color: colorScheme.outlineVariant)
//               : BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(16)),
//           borderSide: isDark
//               ? BorderSide(color: colorScheme.outlineVariant)
//               : BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(16)),
//           borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
//         ),
//       ),
//
//       chipTheme: ChipThemeData(
//         backgroundColor: isDark
//             ? colorScheme.surfaceContainerHighest
//             : colorScheme.surfaceContainerHigh,
//         selectedColor: colorScheme.primaryContainer,
//         side: isDark
//             ? BorderSide(color: colorScheme.outlineVariant)
//             : BorderSide.none,
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
//           elevation: isDark ? 3 : 0,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//         ),
//       ),
//
//       dividerTheme: DividerThemeData(
//         color: colorScheme.outlineVariant,
//         thickness: 1,
//       ),
//     );
//   }
//
//   // Typography
//   static TextTheme _buildTextTheme(bool isDark, ColorScheme colorScheme) {
//     final primaryTextColor = isDark
//         ? AppColors.darkTextPrimary
//         : AppColors.textPrimary;
//     final secondaryTextColor = isDark
//         ? AppColors.darkTextSecondary
//         : AppColors.textSecondary;
//     final hintTextColor = isDark ? AppColors.darkTextHint : AppColors.textHint;
//
//     return TextTheme(
//       displayLarge: TextStyle(
//         fontSize: 57,
//         fontWeight: FontWeight.w400,
//         color: primaryTextColor,
//       ),
//       displayMedium: TextStyle(
//         fontSize: 45,
//         fontWeight: FontWeight.w400,
//         color: primaryTextColor,
//       ),
//       displaySmall: TextStyle(
//         fontSize: 36,
//         fontWeight: FontWeight.w400,
//         color: primaryTextColor,
//       ),
//       headlineLarge: TextStyle(
//         fontSize: 32,
//         fontWeight: FontWeight.w600,
//         color: primaryTextColor,
//       ),
//       headlineMedium: TextStyle(
//         fontSize: 28,
//         fontWeight: FontWeight.w500,
//         color: primaryTextColor,
//       ),
//       headlineSmall: TextStyle(
//         fontSize: 24,
//         fontWeight: FontWeight.w500,
//         color: primaryTextColor,
//       ),
//       titleLarge: TextStyle(
//         fontSize: 22,
//         fontWeight: FontWeight.w500,
//         color: primaryTextColor,
//       ),
//       titleMedium: TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//         color: primaryTextColor,
//       ),
//       titleSmall: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: primaryTextColor,
//       ),
//       bodyLarge: TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         color: primaryTextColor,
//       ),
//       bodyMedium: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w400,
//         color: secondaryTextColor,
//       ),
//       bodySmall: TextStyle(
//         fontSize: 12,
//         fontWeight: FontWeight.w400,
//         color: hintTextColor,
//       ),
//       labelLarge: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: primaryTextColor,
//       ),
//       labelMedium: TextStyle(
//         fontSize: 12,
//         fontWeight: FontWeight.w500,
//         color: secondaryTextColor,
//       ),
//       labelSmall: TextStyle(
//         fontSize: 11,
//         fontWeight: FontWeight.w500,
//         color: hintTextColor,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // --- Brand Color Accessors ---
  static Color get yoBlue => AppColors.yoBlue;
  static Color get yoBlueDark => AppColors.yoBlueDark;
  static Color get yoBlueLight => AppColors.yoBlueLight;

  static Color get yoGreen => AppColors.yoGreen;
  static Color get yoGreenDark => AppColors.yoGreenDark;
  static Color get yoGreenLight => AppColors.yoGreenLight;

  static Color get yoPurple => AppColors.yoPurple;
  static Color get yoPurpleDark => AppColors.yoPurpleDark;
  static Color get yoPurpleLight => AppColors.yoPurpleLight;

  // --- Role Aliases ---
  static Color get primary => AppColors.yoBlue;
  static Color get primaryDark => AppColors.yoBlueDark;
  static Color get primaryLight => AppColors.yoBlueLight;
  static Color get secondary => AppColors.yoGreen;
  static Color get secondaryDark => AppColors.yoGreenDark;
  static Color get secondaryLight => AppColors.yoGreenLight;

  static Color get doctorColor => AppColors.yoBlue;
  static Color get doctorLight => AppColors.yoBlueLight;
  static Color get patientColor => AppColors.yoGreen;
  static Color get patientLight => AppColors.yoGreenLight;

  // --- Interface Canvas ---
  static Color get textPrimary => AppColors.textPrimary;
  static Color get textSecondary => AppColors.textSecondary;
  static Color get textHint => AppColors.textHint;

  static Color get background => AppColors.background;
  static Color get surface => AppColors.surface;
  static Color get divider => AppColors.divider;

  static Color get inputFill => AppColors.inputFill;
  static Color get inputFillGreen => AppColors.inputFillGreen;

  // --- Base Palette ---
  static Color get white => Colors.white;
  static Color get black => Colors.black;
  static Color get transparent => Colors.transparent;
  static MaterialColor get grey => Colors.grey;
  static MaterialColor get green => Colors.green;
  static MaterialColor get red => Colors.red;
  static MaterialColor get orange => Colors.orange;
  static MaterialColor get amber => Colors.amber;

  // --- Adaptive Status Helpers ---
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

  // --- Light Theme Getters ---
  static ThemeData get doctorTheme => _buildTheme(
    colorScheme: AppColors.doctorColorScheme,
    brightness: Brightness.light,
  );

  static ThemeData get patientTheme => _buildTheme(
    colorScheme: AppColors.patientColorScheme,
    brightness: Brightness.light,
  );

  static ThemeData get adminTheme => _buildTheme(
    colorScheme: AppColors.adminColorScheme,
    brightness: Brightness.light,
  );

  // --- Dark Theme Getters ---
  static ThemeData get doctorDarkTheme => _buildTheme(
    colorScheme: AppColors.doctorDarkColorScheme,
    brightness: Brightness.dark,
  );

  static ThemeData get patientDarkTheme => _buildTheme(
    colorScheme: AppColors.patientDarkColorScheme,
    brightness: Brightness.dark,
  );

  static ThemeData get adminDarkTheme => _buildTheme(
    colorScheme: AppColors.adminDarkColorScheme,
    brightness: Brightness.dark,
  );

  // --- Core Theme Engine ---
  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceDim,
      splashFactory: InkSparkle.splashFactory,
      textTheme: _buildTextTheme(isDark, colorScheme),

      // App Bar Configuration
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
          letterSpacing: -0.2,
        ),
      ),

      // Card Design with Hairline Micro-Border
      cardTheme: CardThemeData(
        color: isDark ? colorScheme.surfaceContainer : Colors.white,
        elevation: isDark ? 0 : 2,
        shadowColor: colorScheme.shadow.withValues(alpha: isDark ? 0.35 : 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.55),
            width: 1,
          ),
        ),
      ),

      // Form Text Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? colorScheme.surfaceContainer : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.8,
          ),
        ),
      ),

      // Filter & Action Chips
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        selectedColor: colorScheme.primaryContainer,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        labelStyle: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),

      // Primary Action Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: isDark ? 0 : 2,
          shadowColor: colorScheme.primary.withValues(alpha: 0.28),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // Section Dividers
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        thickness: 1,
      ),
    );
  }

  // --- Clean Typography Architecture ---
  static TextTheme _buildTextTheme(bool isDark, ColorScheme colorScheme) {
    final primaryTextColor =
    isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor =
    isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final hintTextColor =
    isDark ? AppColors.darkTextHint : AppColors.textHint;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 54,
        fontWeight: FontWeight.w800,
        color: primaryTextColor,
        letterSpacing: -1.0,
      ),
      displayMedium: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        color: primaryTextColor,
        letterSpacing: -0.8,
      ),
      displaySmall: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
        letterSpacing: -0.6,
      ),
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: primaryTextColor,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: -0.1,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: primaryTextColor,
        height: 1.45,
      ),
      bodyMedium: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: hintTextColor,
        height: 1.35,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        letterSpacing: 0.2,
      ),
      labelSmall: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        color: hintTextColor,
        letterSpacing: 0.3,
      ),
    );
  }
}