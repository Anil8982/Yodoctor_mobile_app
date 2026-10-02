import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class DateTimelinePicker extends StatelessWidget {
  const DateTimelinePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected, // Can accept null during loading
    required this.onCustomDatePick, // Can accept null during loading
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime>? onDateSelected; // Made nullable
  final VoidCallback? onCustomDatePick; // Made nullable

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final DateTime today = DateTime.now();
    const List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              ...List.generate(7, (index) {
                final DateTime date = today.add(Duration(days: index));
                final bool isSelected = _isSameDay(selectedDate, date);
                final String dayLabel = index == 0
                    ? 'Today'
                    : index == 1
                    ? 'Tom'
                    : weekdays[date.weekday - 1];

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: onDateSelected != null
                        ? () => onDateSelected!(date)
                        : null,
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        // Dim background color if interactions are disabled
                        color: onDateSelected == null && !isSelected
                            ? colorScheme.surfaceContainerHighest.transparency(
                                0.2,
                              )
                            : (isSelected
                                  ? colorScheme.primary
                                  : colorScheme.surfaceContainer),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dayLabel,
                            style: textTheme.labelMedium?.copyWith(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant.withValues(
                                      alpha: onDateSelected == null ? 0.4 : 0.8,
                                    ),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            date.day.toString(),
                            style: textTheme.titleMedium?.copyWith(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface.withValues(
                                      alpha: onDateSelected == null ? 0.4 : 1.0,
                                    ),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              IconButton.filledTonal(
                onPressed: onCustomDatePick, // Disabled automatically when null
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.calendar_month_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Selected Date: ${_formatDate(selectedDate)}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }
}
