import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/patient/models/home_care/home_service_booking_model.dart';
import 'package:yodoctor/modules/patient/controllers/home_service_controller.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';

class BookingServiceDuration extends ConsumerWidget {
  final HomeServiceBookingModel bookingState;
  final TextEditingController daysController;
  final bool showDurationDateError;

  const BookingServiceDuration({
    super.key,
    required this.bookingState,
    required this.daysController,
    required this.showDurationDateError,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homeServiceBookingProvider.notifier);
    final isMultipleDays = bookingState.durationType == 'Multiple Days';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['1 Day', 'Multiple Days', 'Weekly', 'Monthly'].map((
              type,
            ) {
              final isSel = bookingState.durationType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  selected: isSel,
                  label: Text(type),
                  onSelected: (_) {
                    notifier.updateField(durationType: type);
                    if (type != 'Multiple Days') {
                      daysController.clear();
                      notifier.updateField(numberOfDays: '');
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      alignment: Alignment.centerLeft,
                      child: child,
                    ),
                  );
                },
                child: isMultipleDays
                    ? Padding(
                        key: const ValueKey('multiple_days_field'),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppTextField(
                          controller: daysController,
                          label: 'Number of Days',
                          isRequired: true,
                          hint: 'Enter days',
                          icon: Icons.tag_rounded,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          onChanged: (val) =>
                              notifier.updateField(numberOfDays: val),
                          validator: (value) {
                            if (bookingState.durationType == 'Multiple Days') {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              final days = int.tryParse(value.trim());
                              if (days == null || days <= 0) {
                                return 'Invalid days';
                              }
                              if (days > 365) {
                                return 'Max 365 days';
                              }
                            }
                            return null;
                          },
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty_space')),
              ),
            ),
            AppDatePickerField(
              label: 'Start Date',
              isRequired: true,
              hint: 'Select Date',
              icon: Icons.date_range_rounded,
              value: bookingState.startDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (picked) {
                if (picked != null) {
                  notifier.updateField(startDate: picked);
                }
              },
              validator: (val) {
                if (val == null) {
                  return 'Please select start date';
                }
                return null;
              },
            ),
          ],
        ),
        if (showDurationDateError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              bookingState.durationType.trim().isEmpty
                  ? 'Please select service duration'
                  : bookingState.startDate == null
                  ? 'Please select start date'
                  : '',
              style: TextStyle(color: AppTheme.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
