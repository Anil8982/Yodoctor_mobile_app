import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const String primaryFontFamily = 'Roboto';

  static TextTheme get textTheme => const TextTheme(
    displaySmall: TextStyle(
      fontSize: 34,
      height: 1.2,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      height: 1.25,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      height: 1.3,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      height: 1.3,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1.45,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 1.45,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      height: 1.35,
      fontWeight: FontWeight.w400,
    ),
  ).apply(fontFamily: primaryFontFamily);
}
