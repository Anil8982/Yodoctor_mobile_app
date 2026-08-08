import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_field_helper.dart';
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

  const BookingPersonalDetails({
    super.key,
    required this.bookingState,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homeServiceBookingProvider.notifier);

    return Column(
      children: [
        AppTextField(
          controller: nameController,
          label: 'Full Name',
          isRequired: true,
          hint: 'Enter full name',
          icon: Icons.person_rounded,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            SingleSpaceFormatter(),
            LengthLimitingTextInputFormatter(50),
          ],
          onChanged: (val) => notifier.updateField(fullName: val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name is required';
            }
            final cleanedValue = value.trim().replaceAll(RegExp(r'\s+'), ' ');
            if (cleanedValue.length < 2) {
              return "Name should have at least 2 characters";
            }
            if (!RegExp(r'^[A-Za-z. ]+$').hasMatch(cleanedValue)) {
              return 'Only alphabets are allowed';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: phoneController,
          label: 'Contact Number',
          isRequired: true,
          hint: 'Enter contact number',
          icon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (val) => notifier.updateField(contactNumber: val),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Phone number is required';
            }
            if (value.trim().length != 10) {
              return 'Phone number must be exactly 10 digits';
            }
            if (!RegExp(r'^[6-9]').hasMatch(value.trim())) {
              return 'Phone number must start with 6, 7, 8, or 9';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: ageController,
          label: 'Patient Age',
          isRequired: true,
          hint: 'Enter age',
          icon: Icons.calendar_today_rounded,
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (val) => notifier.updateField(patientAge: val),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Age is required';
            }

            final age = int.tryParse(value.trim());

            if (age == null) {
              return 'Enter a valid number';
            }
            if (age <= 0) {
              return 'Age must be greater than 0';
            }
            if (age > 120) {
              return 'Age cannot be more than 120';
            }
            return null;
          },
        ),

        const SizedBox(height: 12),
        AppDropdownField(
          label: 'Patient Gender',
          isRequired: true,
          hint: 'Select Gender',
          icon: Icons.wc_rounded,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          value:
          bookingState.patientGender == 'Select Gender' ||
              bookingState.patientGender.isEmpty
              ? null
              : bookingState.patientGender,
          items: const ['Male', 'Female', 'Other'],
          onChanged: (val) => notifier.updateField(patientGender: val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Select gender';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: addressController,
          label: 'Address',
          isRequired: true,
          hint: 'Enter complete address',
          icon: Icons.location_on_rounded,
          maxLines: 2,
          minLines: 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            LengthLimitingTextInputFormatter(300),
          ],
          onChanged: (val) => notifier.updateField(address: val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Address is required';
            }
            if (value.trim().length < 5) {
              return 'Address should have at least 5 characters';
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
            label: const Text("Use Current Location"),
          ),
        ),
      ],
    );
  }
}