import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class NavButtons extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String backText;
  final String nextText;

  const NavButtons({
    super.key,
    required this.onBack,
    required this.onNext,
    this.backText = 'Back',
    this.nextText = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final Color activePrimaryColor = colorScheme.primary;
    final Color dynamicOnNextColor = activePrimaryColor.contrastColor;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52, // Standardized M3 button touch boundaries
            child: OutlinedButton(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: colorScheme.outlineVariant.transparency(0.5),
                  width: 1.5,
                ),
                foregroundColor: colorScheme.onSurfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_rounded,
                    size: 18,
                    color: onBack == null ? null : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    backText,
                    style: textTheme.titleSmall?.copyWith(
                      color: onBack == null ? null : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                backgroundColor: activePrimaryColor,
                foregroundColor: dynamicOnNextColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                disabledBackgroundColor: colorScheme.onSurface.transparency(0.12),
                disabledForegroundColor: colorScheme.onSurface.transparency(0.38),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    nextText,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: onNext == null ? null : dynamicOnNextColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: onNext == null ? null : dynamicOnNextColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}