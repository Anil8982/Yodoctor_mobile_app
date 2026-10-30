import 'package:flutter/material.dart';

class LabBookingStepContainer extends StatelessWidget {
  final int step;
  final String title;
  final Widget child;

  const LabBookingStepContainer({
    super.key,
    required this.step,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$step',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Container(
            padding: const EdgeInsets.only(left: 22, top: 12, bottom: 4),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
