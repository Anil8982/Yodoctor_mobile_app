import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData? icon;

  const NextButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final Color dynamicOnButtonColor = color.contrastColor;
    final bool isEnabled = onTap != null && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: isEnabled ? onTap : null,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: dynamicOnButtonColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          disabledBackgroundColor:
          theme.colorScheme.onSurface.transparency(0.12),
          disabledForegroundColor:
          theme.colorScheme.onSurface.transparency(0.38),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? SizedBox(
            key: const ValueKey('button_loader'),
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                dynamicOnButtonColor,
              ),
            ),
          )
              : Row(
            key: const ValueKey('button_content'),
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isEnabled ? dynamicOnButtonColor : null,
                  letterSpacing: 0.3,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(
                  icon,
                  size: 20,
                  color: isEnabled ? dynamicOnButtonColor : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}