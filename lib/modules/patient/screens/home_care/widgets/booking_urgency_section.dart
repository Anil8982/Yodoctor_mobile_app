import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/models/home_care/home_service_booking_model.dart';
import 'package:yodoctor/modules/patient/controllers/home_service_controller.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';

class BookingUrgencySection extends ConsumerWidget {
  final HomeServiceBookingModel bookingState;

  const BookingUrgencySection({super.key, required this.bookingState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final notifier = ref.read(homeServiceBookingProvider.notifier);

    return Column(
      children: [
        AppDropdownField<String>(
          label: l10n?.preferredCaregiverGender ?? 'Preferred Caregiver Gender',
          isRequired: true,
          hint: l10n?.selectPreference ?? 'Select Preference',
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
          itemLabelBuilder: (val) {
            switch (val) {
              case 'No Preference':
                return l10n?.noPreference ?? 'No Preference';
              case 'Male':
                return l10n?.genderMale ?? 'Male';
              case 'Female':
                return l10n?.genderFemale ?? 'Female';
              default:
                return val;
            }
          },
          onChanged: (val) => notifier.updateField(preferredCaregiverGender: val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n?.selectGenderPreferenceValidation ??
                  'Please select gender preference';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            l10n?.needEmergencyService ?? 'Need Emergency Service',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            l10n?.within2Hours ?? 'Within 2 hours',
            style: const TextStyle(fontSize: 12),
          ),
          value: bookingState.needEmergencyService,
          activeColor: colorScheme.primary,
          onChanged: (val) => notifier.updateField(needEmergencyService: val ?? false),
        ),
      ],
    );
  }
}