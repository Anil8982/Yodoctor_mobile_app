import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const NextButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final Color dynamicOnButtonColor = color.contrastColor;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: dynamicOnButtonColor,
          elevation: 0,
          // scrolledUnderElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          disabledBackgroundColor: theme.colorScheme.onSurface.transparency(0.12),
          disabledForegroundColor: theme.colorScheme.onSurface.transparency(0.38),
        ),
        child: Text(
          label,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800, // Injected bold standard metrics
            color: onTap == null ? null : dynamicOnButtonColor,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}