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
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> statusOptions = [
      {
        'label': 'FIT',
        'value': 'FIT',
        'icon': Icons.check_circle_outline_rounded,
        'selectedIcon': Icons.check_circle_rounded,
        'activeBg': isDark ? const Color(0xFF132E23) : const Color(0xFFE8F5E9),
        'activeBorder': isDark ? const Color(0xFF2E7D32) : const Color(0xFF4CAF50),
        'activeFg': isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
      },
      {
        'label': 'UNFIT',
        'value': 'UNFIT',
        'icon': Icons.cancel_outlined,
        'selectedIcon': Icons.cancel_rounded,
        'activeBg': isDark ? const Color(0xFF331619) : const Color(0xFFFFEBEE),
        'activeBorder': isDark ? const Color(0xFFC62828) : const Color(0xFFEF5350),
        'activeFg': isDark ? const Color(0xFFE57373) : const Color(0xFFC62828),
      },
      {
        'label': 'TEMP UNFIT',
        'value': 'TEMPORARILY UNFIT',
        'icon': Icons.hourglass_empty_rounded,
        'selectedIcon': Icons.hourglass_full_rounded,
        'activeBg': isDark ? const Color(0xFF332712) : const Color(0xFFFFF8E1),
        'activeBorder': isDark ? const Color(0xFFF57F17) : const Color(0xFFFFB74D),
        'activeFg': isDark ? const Color(0xFFFFD54F) : const Color(0xFFE65100),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'FITNESS ASSESSMENT STATUS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: statusOptions.map((option) {
            final isSelected = selectedStatus.toUpperCase() == option['value'];

            final activeBg = option['activeBg'] as Color;
            final activeBorder = option['activeBorder'] as Color;
            final activeFg = option['activeFg'] as Color;

            // Inactive styles
            final inactiveBg = isDark
                ? const Color(0xFF1E2124)
                : const Color(0xFFF4F5F7);
            final inactiveBorder = isDark
                ? Colors.white10
                : const Color(0xFFE0E0E0);
            final inactiveFg = isDark
                ? const Color(0xFF9E9E9E)
                : const Color(0xFF616161);

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: option['label'] != 'TEMP UNFIT' ? 8 : 0,
                ),
                height: 44,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onChanged(option['value']),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? activeBg : inactiveBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? activeBorder : inactiveBorder,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSelected ? option['selectedIcon'] : option['icon'],
                            size: 16,
                            color: isSelected ? activeFg : inactiveFg,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              option['label'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w900
                                    : FontWeight.w700,
                                color: isSelected ? activeFg : inactiveFg,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
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