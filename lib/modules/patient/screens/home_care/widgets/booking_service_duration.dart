import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
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

  String _getDurationLabel(String type, AppLocalizations? l10n) {
    switch (type) {
      case '1 Day':
        return l10n?.duration1Day ?? '1 Day';
      case 'Multiple Days':
        return l10n?.durationMultipleDays ?? 'Multiple Days';
      case 'Weekly':
        return l10n?.durationWeekly ?? 'Weekly';
      case 'Monthly':
        return l10n?.durationMonthly ?? 'Monthly';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
                  label: Text(_getDurationLabel(type, l10n)),
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
                          label: l10n?.numberOfDays ?? 'Number of Days',
                          isRequired: true,
                          hint: l10n?.enterDays ?? 'Enter days',
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
                                return l10n?.requiredField ?? 'Required';
                              }
                              final days = int.tryParse(value.trim());
                              if (days == null || days <= 0) {
                                return l10n?.invalidDays ?? 'Invalid days';
                              }
                              if (days > 365) {
                                return l10n?.max365Days ?? 'Max 365 days';
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
              label: l10n?.startDate ?? 'Start Date',
              isRequired: true,
              hint: l10n?.selectDate ?? 'Select Date',
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
                  return l10n?.pleaseSelectStartDate ??
                      'Please select start date';
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
                  ? (l10n?.pleaseSelectServiceDuration ??
                      'Please select service duration')
                  : bookingState.startDate == null
                  ? (l10n?.pleaseSelectStartDate ?? 'Please select start date')
                  : '',
              style: TextStyle(color: AppTheme.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
