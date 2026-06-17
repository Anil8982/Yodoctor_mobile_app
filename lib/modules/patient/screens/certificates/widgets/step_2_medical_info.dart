import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'step_header_helper.dart';
import 'custom_text_field.dart';

class Step2MedicalInfo extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final CertificateNotifier controller;

  const Step2MedicalInfo({super.key, required this.formKey, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // Watch current form state reactively from provider
    final formState = ref.watch(certificateProvider);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(title: 'Medical Details', desc: 'Provide baseline biometrics to appear on your medical clearance.'),
          const SizedBox(height: 20),
          CustomCertificateTextField(
            controller: controller.fullNameController,
            labelText: 'Full Name *',
            prefixIcon: Icons.badge_rounded,
            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter name' : null,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomCertificateTextField(
                  controller: controller.dobController,
                  labelText: 'Date of Birth *',
                  prefixIcon: Icons.calendar_today_rounded,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2002, 6, 14),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      controller.dobController.text =
                      '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
                    }
                  },
                  validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: formState.gender,
                  decoration: InputDecoration(
                    labelText: 'Gender *',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
                    ),
                  ),
                  validator: (value) => value == null ? 'Required' : null,
                  items: const ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem<String>(value: g, child: Text(g))).toList(),
                  onChanged: (value) => value != null ? controller.setGender(value) : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: formState.bloodGroup,
                  decoration: InputDecoration(
                    labelText: 'Blood Group *',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
                    ),
                  ),
                  items: const ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].map((bg) => DropdownMenuItem<String>(value: bg, child: Text(bg))).toList(),
                  onChanged: (value) => value != null ? controller.setBloodGroup(value) : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomCertificateTextField(
                  controller: controller.heightController,
                  labelText: 'Height',
                  suffixText: 'CM',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomCertificateTextField(
            controller: controller.weightController,
            labelText: 'Weight',
            suffixText: 'KG',
            prefixIcon: Icons.scale_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          CustomCertificateTextField(
            controller: controller.medicalConditionsController,
            labelText: 'Known Medical Conditions',
            hintText: 'e.g., Diabetes, Hypertension, Asthma',
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          CustomCertificateTextField(
            controller: controller.medicationsController,
            labelText: 'Current Medications',
            hintText: 'e.g., Metformin 500mg, Daily Multivitamins',
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}