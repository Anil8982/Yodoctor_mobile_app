import 'package:flutter/material.dart';

class StatusChipSelector extends StatelessWidget {
  const StatusChipSelector({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  final String selectedStatus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> statusOptions = [
      {
        'label': 'FIT',
        'icon': Icons.check_circle_outline_rounded,
        'selectedIcon': Icons.check_circle_rounded,
        'color': colorScheme.primary,
        'containerColor': colorScheme.primaryContainer,
      },
      {
        'label': 'UNFIT',
        'icon': Icons.cancel_outlined,
        'selectedIcon': Icons.cancel_rounded,
        'color': colorScheme.error,
        'containerColor': colorScheme.errorContainer,
      },
      {
        'label': 'TEMP UNFIT',
        'icon': Icons.hourglass_empty_rounded,
        'selectedIcon': Icons.hourglass_full_rounded,
        'color': colorScheme.tertiary,
        'containerColor': colorScheme.tertiaryContainer,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'FITNESS ASSESSMENT STATUS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: statusOptions.map((option) {
            final selected = selectedStatus.toUpperCase();

            final isSelected = option['label'] == 'TEMP UNFIT'
                ? selected == 'TEMPORARILY UNFIT'
                : selected == option['label'];

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: option['label'] != 'TEMP UNFIT' ? 8 : 0,
                ),
                height: 46,
                child: InkWell(
                  onTap: () => onChanged(
                    option['label'] == 'TEMP UNFIT'
                        ? 'TEMPORARILY UNFIT'
                        : option['label'],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? option['containerColor'].withValues(alpha: 0.35)
                          : colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? option['color']
                            : colorScheme.outlineVariant.withValues(alpha: 0.3),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? option['selectedIcon'] : option['icon'],
                          size: 16,
                          color: isSelected
                              ? option['color']
                              : colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.8,
                                ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          option['label'],
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w900
                                : FontWeight.w800,
                            color: isSelected
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                            fontSize: 11,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
