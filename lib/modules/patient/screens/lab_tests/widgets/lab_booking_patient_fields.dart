import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/app_constants.dart';
import 'package:yodoctor/core/utils/app_field_helper.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autovalidateMode = hasSubmitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return Column(
      children: [
        AppTextField(
          label: 'Full Name',
          isRequired: true,
          hint: 'Enter your full name',
          maxLength: 50,
          icon: Icons.person_outline_rounded,
          controller: nameController,
          autovalidateMode: autovalidateMode,
          textCapitalization: TextCapitalization.words,
          inputFormatters: [SingleSpaceFormatter()],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter your full name';
            }
            if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value.trim())) {
              return 'Only alphabets are allowed';
            }
            if (value.trim().length < 3) {
              return 'Name must be at least 3 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: 'Age',
          isRequired: true,
          hint: 'Age',
          icon: Icons.calendar_today_outlined,
          controller: ageController,
          autovalidateMode: autovalidateMode,
          keyboardType: TextInputType.number,
          maxLength: 3,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Enter age';
            final age = int.tryParse(value);
            if (age == null) return 'Invalid age';
            if (age < 1 || age > 120) {
              return 'Age must be between 1 and 120';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: 'Phone Number',
          isRequired: true,
          hint: 'Enter 10-digit number',
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
              return 'Enter phone number';
            }
            if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
              return 'Enter valid 10-digit number';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        AppDropdownField<String>(
          label: 'Gender',
          isRequired: true,
          hint: 'Select Gender',
          icon: Icons.people_alt_outlined,
          value: state.gender.isNotEmpty ? state.gender : null,
          items: AppConstants.genderOptions,
          autovalidateMode: autovalidateMode,
          onChanged: (value) => ref
              .read(labBookingProvider.notifier)
              .updatePatientDetails(gender: value),
        ),
      ],
    );
  }
}
