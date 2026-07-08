import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/patient/home_service_booking_model.dart';
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
