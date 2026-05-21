import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  final int currentStep; // 1-indexed (1 to 4)
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Divider/Connector line
                final stepIndex = (index / 2).floor() + 1;
                final isCompleted = stepIndex < currentStep;

                return Expanded(
                  child: Container(
                    height: 3,
                    color: isCompleted
                        ? colorScheme.primary
                        : colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                );
              }

              // Step indicator node
              final stepIndex = (index / 2).floor() + 1;
              final isCompleted = stepIndex < currentStep;
              final isActive = stepIndex == currentStep;
              final label = steps[stepIndex - 1];

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? colorScheme.primaryContainer
                          : (isActive ? colorScheme.primary : Colors.transparent),
                      border: Border.all(
                        color: isCompleted || isActive
                            ? colorScheme.primary
                            : colorScheme.outline,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: colorScheme.onPrimaryContainer,
                            )
                          : Text(
                              '$stepIndex',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isActive
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isActive
                          ? colorScheme.primary
                          : (isCompleted
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant),
                      fontWeight: isActive || isCompleted
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
