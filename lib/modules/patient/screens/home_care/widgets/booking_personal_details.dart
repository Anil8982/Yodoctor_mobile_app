import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_field_helper.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/models/home_care/home_service_booking_model.dart';
import 'package:yodoctor/modules/patient/controllers/home_service_controller.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class BookingPersonalDetails extends ConsumerWidget {
  final HomeServiceBookingModel bookingState;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController addressController;
  final bool hasSubmitted;

  const BookingPersonalDetails({
    super.key,
    required this.bookingState,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.addressController,
    this.hasSubmitted = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final autovalidateMode = hasSubmitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;
    final notifier = ref.read(homeServiceBookingProvider.notifier);

    return Column(
      children: [
        AppTextField(
          controller: nameController,
          label: l10n?.fullName ?? 'Full Name',
          isRequired: true,
          hint: l10n?.enterFullName ?? 'Enter full name',
          icon: Icons.person_rounded,
          autovalidateMode: autovalidateMode,
          inputFormatters: [
            SingleSpaceFormatter(),
            LengthLimitingTextInputFormatter(50),
          ],
          onChanged: (val) => notifier.updateField(fullName: val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n?.fullNameRequired ?? 'Full name required';
            }
            final cleanedValue = value.trim().replaceAll(RegExp(r'\s+'), ' ');
            if (cleanedValue.length < 2) {
              return l10n?.enterValidName ?? "Enter a valid name";
            }
            if (!RegExp(r'^[A-Za-z. ]+$').hasMatch(cleanedValue)) {
              return l10n?.onlyAlphabetsAllowed ?? 'Only alphabets are allowed';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: phoneController,
          label: l10n?.contactNumber ?? 'Contact Number',
          isRequired: true,
          hint: l10n?.enterContactNumber ?? 'Enter contact number',
          icon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
          autovalidateMode: autovalidateMode,
          onChanged: (val) => notifier.updateField(contactNumber: val),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n?.phoneRequired ?? 'Phone number is required';
            }
            if (!RegExp(r'^[6-9]').hasMatch(value.trim())) {
              return l10n?.phoneInvalidPrefix ??
                  'Phone no. must start with 6, 7, 8, or 9';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: ageController,
          label: l10n?.patientAge ?? 'Patient Age',
          isRequired: true,
          hint: l10n?.enterAge ?? 'Enter age',
          icon: Icons.calendar_today_rounded,
          keyboardType: TextInputType.number,
          autovalidateMode: autovalidateMode,
          onChanged: (val) => notifier.updateField(patientAge: val),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n?.ageRequired ?? 'Age is required';
            }

            final age = int.tryParse(value.trim());

            if (age == null) {
              return l10n?.enterValidNumber ?? 'Enter a valid number';
            }
            if (age <= 0) {
              return l10n?.ageMinValidation ?? 'Age must be greater than 0';
            }
            if (age > 120) {
              return l10n?.ageMaxValidation ?? 'Age cannot be more than 120';
            }
            return null;
          },
        ),

        const SizedBox(height: 12),
        AppDropdownField<String>(
          label: l10n?.patientGender ?? 'Patient Gender',
          isRequired: true,
          hint: l10n?.selectGender ?? 'Select Gender',
          icon: Icons.wc_rounded,
          autovalidateMode: autovalidateMode,
          value:
              bookingState.patientGender == 'Select Gender' ||
                  bookingState.patientGender.isEmpty
              ? null
              : bookingState.patientGender,
          items: const ['Male', 'Female', 'Other'],
          itemLabelBuilder: (val) {
            switch (val) {
              case 'Male':
                return l10n?.genderMale ?? 'Male';
              case 'Female':
                return l10n?.genderFemale ?? 'Female';
              case 'Other':
                return l10n?.genderOther ?? 'Other';
              default:
                return val;
            }
          },
          onChanged: (val) => notifier.updateField(patientGender: val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n?.selectGenderValidation ?? 'Select gender';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: addressController,
          label: l10n?.address ?? 'Address',
          isRequired: true,
          hint: l10n?.enterCompleteAddress ?? 'Enter complete address',
          icon: Icons.location_on_rounded,
          maxLines: 2,
          minLines: 1,
          autovalidateMode: autovalidateMode,
          inputFormatters: [LengthLimitingTextInputFormatter(300)],
          onChanged: (val) => notifier.updateField(address: val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n?.addressRequired ?? 'Address is required';
            }
            if (value.trim().length < 5) {
              return l10n?.addressMinValidation ??
                  'Address at least 5 characters';
            }
            return null;
          },
        ),

        const SizedBox(height: 10),

        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: () {
              notifier.fetchCurrentLocation(addressController);
            },
            icon: const Icon(Icons.my_location),
            label: Text(l10n?.useCurrentLocation ?? "Use Current Location"),
          ),
        ),
      ],
    );
  }
}
