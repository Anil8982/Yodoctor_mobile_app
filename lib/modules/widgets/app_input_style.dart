import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class AppInputStyle {
  static InputDecoration decoration({
    required BuildContext context,
    required String hint,
    required IconData icon,
    required bool hasError,
    bool enabled = true,
    Widget? suffixIcon,
    bool isDropdown = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final borderRadius = BorderRadius.circular(14);

    return InputDecoration(
      hintText: hint,

      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),

      prefixIcon: Icon(
        icon,
        color: !enabled
            ? colorScheme.onSurface.transparency(0.38)
            : (hasError ? colorScheme.error : colorScheme.primary),
        size: 20,
      ),
      prefixIconConstraints: BoxConstraints(
        minWidth: 48,
        minHeight: isDropdown ? 40 : 48,
      ),
      suffixIcon: suffixIcon,
      filled: true,

      fillColor: enabled
          ? colorScheme.surfaceContainer
          : colorScheme.surfaceContainerHighest.transparency(0.5),

      counterText: '',

      errorStyle: const TextStyle(height: 0, fontSize: 0),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isDropdown ? 14 : 16,
      ),

      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: hasError ? colorScheme.error : colorScheme.outlineVariant,
          width: hasError ? 1.4 : 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: hasError ? colorScheme.error : colorScheme.primary,
          width: 1.8,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.transparency(0.3),
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.error, width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.error, width: 1.8),
      ),
    );
  }
}
