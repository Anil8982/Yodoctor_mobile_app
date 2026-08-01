import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/input_decoration_helper.dart';
import 'package:yodoctor/modules/patient/controllers/booking_controller.dart';
import 'package:yodoctor/modules/patient/models/lab/booking_state_model.dart';

class LabBookingPatientFields extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController phoneController;
  final BookingStateModel state;

  const LabBookingPatientFields({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.phoneController,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: nameController,
                decoration: AppInputDecoration.build(
                  context,
                  label: 'Full Name *',
                  prefixIcon: Icons.person_outline_rounded,
                ),
                onChanged: (val) => ref
                    .read(labBookingProvider.notifier)
                    .updatePatientDetails(name: val),
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
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 90,
              child: TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: AppInputDecoration.build(context, label: 'Age *'),
                onChanged: (val) => ref
                    .read(labBookingProvider.notifier)
                    .updatePatientDetails(age: val),
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
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: AppInputDecoration.build(
            context,
            label: 'Phone Number *',
            prefixIcon: Icons.phone_android_rounded,
          ),
          onChanged: (val) => ref
              .read(labBookingProvider.notifier)
              .updatePatientDetails(phone: val),
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
        Row(
          children: ['Male', 'Female', 'Other'].map((gender) {
            final isSelected = state.gender == gender;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => ref
                      .read(labBookingProvider.notifier)
                      .updatePatientDetails(gender: gender),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest.withValues(
                              alpha: 0.4,
                            ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        gender,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
