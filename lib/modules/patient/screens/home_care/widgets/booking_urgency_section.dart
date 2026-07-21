import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/models/home_care/home_service_booking_model.dart';
import 'package:yodoctor/core/utils/input_decoration_helper.dart';
import 'package:yodoctor/modules/patient/controllers/home_service_controller.dart';

class BookingUrgencySection extends ConsumerWidget {
  final HomeServiceBookingModel bookingState;

  const BookingUrgencySection({super.key, required this.bookingState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final notifier = ref.read(homeServiceBookingProvider.notifier);

    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: bookingState.preferredCaregiverGender,
          decoration: AppInputDecoration.build(
            context,
            label: 'Preferred Caregiver Gender *',
            prefixIcon: Icons.face_rounded,
          ),
          items: [
            'No Preference',
            'Male',
            'Female',
          ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
          onChanged: (val) =>
              notifier.updateField(preferredCaregiverGender: val),
          validator: (value) {
            if (value == null) {
              return 'Please select gender';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Need Emergency Service',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: const Text(
            'Within 2 hours',
            style: TextStyle(fontSize: 12),
          ),
          value: bookingState.needEmergencyService,
          activeColor: colorScheme.primary,
          onChanged: (val) => notifier.updateField(needEmergencyService: val),
        ),
      ],
    );
  }
}
