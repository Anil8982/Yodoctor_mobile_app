import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/patient/controllers/booking_controller.dart';
import 'package:yodoctor/modules/patient/models/lab/booking_state_model.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

class LabBookingDateTime extends ConsumerWidget {
  final BookingStateModel state;

  const LabBookingDateTime({super.key, required this.state});

  bool _isAnySlotAvailableForToday() {
    final allSlots = [
      '6:30 AM',
      '7:00 AM',
      '7:30 AM',
      '8:00 AM',
      '8:30 AM',
      '9:00 AM',
      '9:30 AM',
      '10:00 AM',
      '12:00 PM',
      '12:30 PM',
      '1:00 PM',
      '1:30 PM',
      '2:00 PM',
      '2:30 PM',
      '5:30 PM',
      '6:00 PM',
      '6:30 PM',
      '7:00 PM',
      '7:30 PM',
      '8:00 PM',
    ];

    for (var slot in allSlots) {
      if (_isTimeSlotValid(slot, DateTime.now())) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (DateUtils.isSameDay(state.selectedDate, DateTime.now())) {
        if (!_isAnySlotAvailableForToday()) {
          final tomorrow = DateTime.now().add(const Duration(days: 1));

          ref.read(labBookingProvider.notifier).selectDate(tomorrow);

          AppSnackBar.show(
            message: "Today's slots are closed. select other day slots",
            type: AppSnackBarType.info,
          );
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDateGrid(context, ref),
        const SizedBox(height: 24),
        _buildTimeSlotsSection(context, ref),
      ],
    );
  }

  Widget _buildDateGrid(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<DateTime> dates = List.generate(
      6,
      (index) => DateTime.now().add(Duration(days: index)),
    );
    return SizedBox(
      height: 64,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = DateUtils.isSameDay(state.selectedDate, date);
          final isToday = DateUtils.isSameDay(DateTime.now(), date);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () =>
                  ref.read(labBookingProvider.notifier).selectDate(date),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 58,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.3,
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.transparent
                        : colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isToday ? 'TODAY' : _getWeekdayName(date.weekday),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isSelected ? colorScheme.onPrimary : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isTimeSlotValid(String slot, DateTime selectedDate) {
    if (!DateUtils.isSameDay(selectedDate, DateTime.now())) {
      return true;
    }

    try {
      final now = DateTime.now();
      final parts = slot.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      if (parts[1] == 'PM' && hour != 12) hour += 12;
      if (parts[1] == 'AM' && hour == 12) hour = 0;

      final slotDateTime = DateTime(now.year, now.month, now.day, hour, minute);

      return slotDateTime.isAfter(now);
    } catch (e) {
      return true;
    }
  }

  Widget _buildTimeSlotsSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShiftGroup(context, ref, 'Morning Slot', [
          '6:30 AM',
          '7:00 AM',
          '7:30 AM',
          '8:00 AM',
          '8:30 AM',
          '9:00 AM',
          '9:30 AM',
          '10:00 AM',
        ]),
        const SizedBox(height: 16),
        _buildShiftGroup(context, ref, 'Afternoon Slot', [
          '12:00 PM',
          '12:30 PM',
          '1:00 PM',
          '1:30 PM',
          '2:00 PM',
          '2:30 PM',
        ]),
        const SizedBox(height: 16),
        _buildShiftGroup(context, ref, 'Evening Slot', [
          '5:30 PM',
          '6:00 PM',
          '6:30 PM',
          '7:00 PM',
          '7:30 PM',
          '8:00 PM',
        ]),
      ],
    );
  }

  Widget _buildShiftGroup(
    BuildContext context,
    WidgetRef ref,
    String shiftTitle,
    List<String> slots,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shiftTitle,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.outline,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots.map((slot) {
            final isValid = _isTimeSlotValid(slot, state.selectedDate);
            final isSelected = state.selectedTimeSlot == slot;

            return Opacity(
              opacity: isValid ? 1.0 : 0.4,
              child: InkWell(
                onTap: isValid
                    ? () => ref
                          .read(labBookingProvider.notifier)
                          .selectTimeSlot(slot)
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? colorScheme.primary : theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.transparent
                          : colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : (isValid
                                ? colorScheme.onSurface
                                : colorScheme.outline),
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

  String _getWeekdayName(int weekday) {
    const names = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return names[weekday - 1];
  }
}
