import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/models/home_care/home_service_booking_model.dart';
import 'package:yodoctor/core/utils/input_decoration_helper.dart';
import 'package:yodoctor/modules/patient/controllers/home_service_controller.dart';

class BookingServiceDuration extends ConsumerWidget {
  final HomeServiceBookingModel bookingState;
  final TextEditingController daysController;

  const BookingServiceDuration({
    super.key,
    required this.bookingState,
    required this.daysController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(homeServiceBookingProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['1 Day', 'Multiple Days', 'Weekly', 'Monthly'].map((type) {
              final isSel = bookingState.durationType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  selected: isSel,
                  label: Text(type),
                  onSelected: (_) => notifier.updateField(durationType: type),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            if (bookingState.durationType == 'Multiple Days')
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: TextFormField(
                    controller: daysController,
                    keyboardType: TextInputType.number,
                    decoration: AppInputDecoration.build(
                      context,
                      label: 'Number of Days',
                      prefixIcon: Icons.tag_rounded,
                    ),
                    onChanged: (val) => notifier.updateField(numberOfDays: val),
                  ),
                ),
              ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) {
                    notifier.updateField(startDate: picked);
                  }
                },
                child: InputDecorator(
                  decoration: AppInputDecoration.build(
                    context,
                    label: 'Start Date',
                    prefixIcon: Icons.date_range_rounded,
                  ),
                  child: Text(
                    bookingState.startDate != null
                        ? '${bookingState.startDate!.day}/${bookingState.startDate!.month}/${bookingState.startDate!.year}'
                        : 'Select Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: bookingState.startDate == null ? theme.hintColor : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}