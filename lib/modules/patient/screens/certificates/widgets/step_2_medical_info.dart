import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/app_constants.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'step_header_helper.dart';

class Step2MedicalInfo extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final CertificateNotifier controller;
  final AutovalidateMode autovalidateMode;

  const Step2MedicalInfo({
    super.key,
    required this.formKey,
    required this.controller,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current form state reactively from provider
    final formState = ref.watch(certificateProvider);

    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
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
            label: 'Full Name',
            isRequired: true,
            hint: 'Enter your full name',
            icon: Icons.badge_rounded,
            controller: controller.fullNameController,
            textCapitalization: TextCapitalization.words,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Enter name';
              }
              if (v.trim().length < 3) {
                return 'Enter a valid name';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),
          AppDatePickerField(
            label: 'Date of Birth',
            isRequired: true,
            hint: 'Select DOB',
            icon: Icons.cake_rounded,
            value: formState.dateOfBirth,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            onChanged: (date) {
              controller.selectDateOfBirth(date);
            },
            validator: (date) {
              if (date == null) {
                return 'Select date of birth';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppDropdownField<String>(
                  label: 'Gender',
                  isRequired: true,
                  hint: 'Select gender',
                  icon: Icons.wc_rounded,
                  value: formState.gender,
                  items: AppConstants.genderOptions,
                  onChanged: (value) =>
                      value != null ? controller.setGender(value) : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select gender';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppDropdownField<String>(
                  label: 'Blood Group',
                  hint: 'Select blood group',
                  icon: Icons.bloodtype_rounded,
                  value: formState.bloodGroup,
                  items: AppConstants.bloodGroupOptions,
                  onChanged: (value) =>
                      value != null ? controller.setBloodGroup(value) : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Height (CM)',
                  hint: 'e.g. 170',
                  maxLength: 3,
                  icon: Icons.height_rounded,
                  controller: controller.heightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d?$')),
                  ],
                  validator: (String? value) {
                    final String text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return null;
                    }
                    final double? parsed = double.tryParse(text);
                    if (parsed == null) {
                      return 'Enter valid height';
                    }
                    if (parsed < 30 || parsed > 250) {
                      return 'B/w 30 and 250 cm';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  label: 'Weight (KG)',
                  hint: 'e.g. 65',
                  maxLength: 3,
                  icon: Icons.monitor_weight_outlined,
                  controller: controller.weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d?$')),
                  ],
                  validator: (String? value) {
                    final String text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return null;
                    }
                    final double? parsed = double.tryParse(text);
                    if (parsed == null) {
                      return 'Enter valid weight';
                    }
                    if (parsed < 2 || parsed > 350) {
                      return 'B/w 2 and 350 kg';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: 'Known Medical Conditions',
            hint: 'e.g., Diabetes, Hypertension, Asthma',
            icon: Icons.note_alt_sharp,
            controller: controller.medicalConditionsController,
            maxLines: 2,
          ),

          const SizedBox(height: 20),
          AppTextField(
            label: 'Current Medications',
            hint: 'e.g., Metformin 500mg, Daily Multivitamins',
            icon: Icons.notes,
            controller: controller.medicationsController,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
