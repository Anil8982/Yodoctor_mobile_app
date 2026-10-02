import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/models/home_care/home_service_booking_model.dart';
import 'package:yodoctor/modules/patient/controllers/home_service_controller.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';

class BookingUrgencySection extends ConsumerWidget {
  final HomeServiceBookingModel bookingState;

  const BookingUrgencySection({super.key, required this.bookingState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final notifier = ref.read(homeServiceBookingProvider.notifier);

    return Column(
      children: [
        AppDropdownField(
          label: 'Preferred Caregiver Gender',
          isRequired: true,
          hint: 'Select Preference',
          icon: Icons.face_rounded,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          value: bookingState.preferredCaregiverGender.isEmpty
              ? null
              : bookingState.preferredCaregiverGender,
          items: const [
            'No Preference',
            'Male',
            'Female',
          ],
          onChanged: (val) => notifier.updateField(preferredCaregiverGender: val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please select gender preference';
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
          onChanged: (val) => notifier.updateField(needEmergencyService: val ?? false),
        ),
      ],
    );
  }
}