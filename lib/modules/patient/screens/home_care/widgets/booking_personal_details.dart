import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/models/home_care/home_service_booking_model.dart';
import 'package:yodoctor/core/utils/input_decoration_helper.dart';
import 'package:yodoctor/modules/patient/controllers/home_service_controller.dart';

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
        TextFormField(
          controller: nameController,
          decoration: AppInputDecoration.build(
            context,
            label: 'Full Name *',
            prefixIcon: Icons.person_rounded,
          ),
          onChanged: (val) => notifier.updateField(fullName: val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name is required';
            }
            if (value.trim().length < 2) {
              return "Name should have at least 2 characters";
            }
            if (!RegExp(r'^[A-Za-z. ]+$').hasMatch(value.trim())) {
              return 'Only alphabets are allowed';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: AppInputDecoration.build(
            context,
            label: 'Contact Number *',
            prefixIcon: Icons.phone_android_rounded,
          ),
          onChanged: (val) => notifier.updateField(contactNumber: val),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Phone number is required';
            }

            if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
              return 'Enter a valid phone number';
            }

            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: AppInputDecoration.build(
                  context,
                  label: 'Patient Age *',
                  prefixIcon: Icons.calendar_today_rounded,
                ),
                onChanged: (val) => notifier.updateField(patientAge: val),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Age is required';
                  }

                  final age = int.tryParse(value);

                  if (age == null || age <= 0 || age > 120) {
                    return 'Enter valid age';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: bookingState.patientGender == 'Select Gender'
                    ? null
                    : bookingState.patientGender,
                decoration: AppInputDecoration.build(
                  context,
                  label: 'Patient Gender *',
                  prefixIcon: Icons.wc_rounded,
                ),
                items: ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => notifier.updateField(patientGender: val),
                validator: (value) {
                  if (value == null) {
                    return 'Select gender';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: addressController,
          maxLines: 2,
          decoration: AppInputDecoration.build(
            context,
            label: 'Address *',
            prefixIcon: Icons.location_on_rounded,
          ),
          onChanged: (val) => notifier.updateField(address: val),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Address is required';
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
