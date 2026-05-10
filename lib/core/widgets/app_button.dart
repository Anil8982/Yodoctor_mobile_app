import 'package:flutter/material.dart';

import '../utils/app_radius.dart';

enum AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.height = 48,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final Widget content = isLoading
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (leading != null) ...<Widget>[
                leading!,
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final ButtonStyle baseStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll<Size>(Size(0, height)),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(padding),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
    );

    switch (variant) {
      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: baseStyle.copyWith(
            foregroundColor: WidgetStatePropertyAll<Color?>(foregroundColor),
          ),
          child: content,
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: baseStyle.copyWith(
            foregroundColor: WidgetStatePropertyAll<Color?>(foregroundColor),
          ),
          child: content,
        );
      case AppButtonVariant.filled:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: baseStyle.copyWith(
            backgroundColor: WidgetStatePropertyAll<Color?>(backgroundColor),
            foregroundColor: WidgetStatePropertyAll<Color?>(foregroundColor),
          ),
          child: content,
        );
    }
  }
}
