import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/app_constants.dart';
import 'package:yodoctor/core/utils/app_field_helper.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/controllers/booking_controller.dart';
import 'package:yodoctor/modules/patient/models/lab/booking_state_model.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class LabBookingPatientFields extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController phoneController;
  final BookingStateModel state;
  final bool hasSubmitted;

  const LabBookingPatientFields({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.phoneController,
    required this.state,
    this.hasSubmitted = false,
  });

  String _getGenderLabel(AppLocalizations? l10n, String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return l10n?.genderMale ?? 'Male';
      case 'female':
        return l10n?.genderFemale ?? 'Female';
      case 'other':
        return l10n?.genderOther ?? 'Other';
      default:
        return gender;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final autovalidateMode = hasSubmitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return Column(
      children: [
        AppTextField(
          label: l10n?.fullName ?? 'Full Name',
          isRequired: true,
          hint: l10n?.enterYourFullName ?? 'Enter your full name',
          maxLength: 50,
          icon: Icons.person_outline_rounded,
          controller: nameController,
          autovalidateMode: autovalidateMode,
          textCapitalization: TextCapitalization.words,
          inputFormatters: [SingleSpaceFormatter()],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n?.enterYourFullName ?? 'Enter your full name';
            }
            if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value.trim())) {
              return l10n?.onlyAlphabetsAllowed ?? 'Only alphabets are allowed';
            }
            if (value.trim().length < 3) {
              return l10n?.nameMin3Characters ?? 'Name must be at least 3 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: l10n?.age ?? 'Age',
          isRequired: true,
          hint: l10n?.age ?? 'Age',
          icon: Icons.calendar_today_outlined,
          controller: ageController,
          autovalidateMode: autovalidateMode,
          keyboardType: TextInputType.number,
          maxLength: 3,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n?.enterAge ?? 'Enter age';
            }
            final age = int.tryParse(value);
            if (age == null) return l10n?.invalidAge ?? 'Invalid age';
            if (age < 1 || age > 120) {
              return l10n?.ageRangeError ?? 'Age must be between 1 and 120';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: l10n?.phoneNumber ?? 'Phone Number',
          isRequired: true,
          hint: l10n?.enter10DigitNumber ?? 'Enter 10-digit number',
          icon: Icons.phone_android_rounded,
          controller: phoneController,
          autovalidateMode: autovalidateMode,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n?.enterPhoneNumber ?? 'Enter phone number';
            }
            if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
              return l10n?.enterValid10DigitNumber ?? 'Enter valid 10-digit number';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        AppDropdownField<String>(
          label: l10n?.gender ?? 'Gender',
          isRequired: true,
          hint: l10n?.selectGender ?? 'Select Gender',
          icon: Icons.people_alt_outlined,
          value: state.gender.isNotEmpty ? state.gender : null,
          items: AppConstants.genderOptions,
          itemLabelBuilder: (g) => _getGenderLabel(l10n, g),
          autovalidateMode: autovalidateMode,
          onChanged: (value) => ref
              .read(labBookingProvider.notifier)
              .updatePatientDetails(gender: value),
        ),
      ],
    );
  }
}
