import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class AppFieldWrapper extends StatelessWidget {
  final String label;
  final bool isRequired;
  final bool enabled;
  final bool hasError;
  final String? activeError;
  final Widget child;

  const AppFieldWrapper({
    super.key,
    required this.label,
    this.isRequired = false,
    this.enabled = true,
    required this.hasError,
    this.activeError,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: enabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.transparency(0.38),
            ),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.error,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Stack(
          clipBehavior: Clip.none,
          children: [
            child,

            Positioned(
              top: -10,
              right: 14,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                reverseDuration: const Duration(milliseconds: 150),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    alignment: Alignment.centerRight,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: hasError && activeError != null && activeError!.isNotEmpty
                    ? Container(
                  key: ValueKey<String>(activeError!),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.error.transparency(0.30),
                        blurRadius: 6,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_rounded,
                        size: 12,
                        color: colorScheme.onError,
                      ),
                      const SizedBox(width: 4),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: Text(
                          activeError!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onError,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('empty_error')),
              ),
            ),
          ],
        ),
      ],
    );
  }
}