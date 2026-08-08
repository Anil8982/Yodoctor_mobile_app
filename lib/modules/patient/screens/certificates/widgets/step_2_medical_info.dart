import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_field_helper.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'step_header_helper.dart';

class Step2MedicalInfo extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final CertificateNotifier controller;

  const Step2MedicalInfo({
    super.key,
    required this.formKey,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current form state reactively from provider
    final formState = ref.watch(certificateProvider);

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            title: 'Medical Details',
            desc:
            'Provide baseline biometrics to appear on your medical clearance.',
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: controller.fullNameController,
            label: 'Full Name',
            isRequired: true,
            hint: 'Enter full name',
            icon: Icons.badge_rounded,
            inputFormatters: [
              SingleSpaceFormatter(),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter name';
              }

              final cleanedValue = value.trim().replaceAll(RegExp(r'\s+'), ' ');

              if (cleanedValue.length < 2) {
                return 'Name should have at least 2 characters';
              }

              if (!RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$').hasMatch(cleanedValue)) {
                return 'Only alphabets are allowed';
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
          AppDatePickerField(
            label: 'Date of Birth',
            isRequired: true,
            hint: 'Select Date',
            icon: Icons.calendar_today_rounded,
            value: controller.dobController.text.isNotEmpty
                ? _parseDate(controller.dobController.text)
                : null,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            onChanged: (date) {
              if (date != null) {
                controller.dobController.text =
                '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
              }
            },
            validator: (value) => controller.dobController.text.trim().isEmpty
                ? 'Required'
                : null,
          ),
          const SizedBox(height: 20),
          AppDropdownField(
            label: 'Gender',
            isRequired: true,
            hint: 'Select Gender',
            icon: Icons.people_outline_rounded,
            value: formState.gender,
            items: const ['Male', 'Female', 'Other'],
            onChanged: (value) =>
            value != null ? controller.setGender(value) : null,
            validator: (value) =>
            value == null || value.trim().isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          AppDropdownField(
            label: 'Blood Group',
            hint: 'Select Blood Group',
            icon: Icons.bloodtype_outlined,
            value: formState.bloodGroup,
            items: const ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
            onChanged: (value) =>
            value != null ? controller.setBloodGroup(value) : null,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: controller.heightController,
            label: 'Height',
            hint: 'e.g. 175',
            icon: Icons.height_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                final height = double.tryParse(value.trim());
                if (height == null) {
                  return 'Enter a valid number';
                }
                if (height <= 0 || height > 300) {
                  return 'Enter a valid height (1 - 300 cm)';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: controller.weightController,
            label: 'Weight',
            hint: 'e.g. 70',
            icon: Icons.scale_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                final weight = double.tryParse(value.trim());
                if (weight == null) {
                  return 'Enter a valid number';
                }
                if (weight <= 0 || weight > 500) {
                  return 'Enter a valid weight (1 - 500 kg)';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: controller.medicalConditionsController,
            label: 'Known Medical Conditions',
            hint: 'e.g., Diabetes, Hypertension, Asthma',
            icon: Icons.medical_information_outlined,
            maxLines: 2,
            minLines: 1,
            maxLength: 2000,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: controller.medicationsController,
            label: 'Current Medications',
            hint: 'e.g., Metformin 500mg, Daily Multivitamins',
            icon: Icons.medication_outlined,
            maxLines: 2,
            minLines: 1,
            maxLength: 3000,
          ),
        ],
      ),
    );
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}
    return null;
  }
}