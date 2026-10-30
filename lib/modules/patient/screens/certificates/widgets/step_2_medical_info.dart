import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_field_helper.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'step_header_helper.dart';

class Step2MedicalInfo extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final CertificateNotifier controller;
  final AutovalidateMode? autovalidateMode;

  const Step2MedicalInfo({
    super.key,
    required this.formKey,
    required this.controller,
    this.autovalidateMode,
  });

  String _getLocalizedGender(String gender, AppLocalizations l10n) {
    switch (gender) {
      case 'Male':
        return l10n.genderMale;
      case 'Female':
        return l10n.genderFemale;
      case 'Other':
        return l10n.genderOther;
      default:
        return gender;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current form state reactively from provider
    final formState = ref.watch(certificateProvider);
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: l10n.medicalDetails,
            desc: l10n.medicalDetailsDesc,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: controller.fullNameController,
            label: l10n.fullName,
            isRequired: true,
            hint: l10n.enterFullName,
            icon: Icons.badge_rounded,
            textCapitalization: TextCapitalization.words,
            inputFormatters: [
              SingleSpaceFormatter(),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterName;
              }

              final cleanedValue = value.trim().replaceAll(RegExp(r'\s+'), ' ');

              if (cleanedValue.length < 2) {
                return l10n.nameMinCharacters;
              }

              if (!RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$').hasMatch(cleanedValue)) {
                return l10n.onlyAlphabetsAllowed;
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
          AppDatePickerField(
            label: l10n.dateOfBirth,
            isRequired: true,
            hint: l10n.selectDate,
            icon: Icons.calendar_today_rounded,
            value: formState.dateOfBirth,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            onChanged: (date) {
              if (date != null) {
                controller.selectDateOfBirth(date);
              }
            },
            validator: (value) {
              if (formState.dateOfBirth == null) {
                return l10n.requiredField;
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
                  label: l10n.gender,
                  isRequired: true,
                  hint: l10n.selectGender,
                  icon: Icons.people_outline_rounded,
                  value: formState.gender,
                  items: const ['Male', 'Female', 'Other'],
                  itemLabelBuilder: (item) => _getLocalizedGender(item, l10n),
                  onChanged: (value) =>
                      value != null ? controller.setGender(value) : null,
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? l10n.requiredField : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppDropdownField<String>(
                  label: l10n.bloodGroup,
                  hint: l10n.selectBloodGroup,
                  icon: Icons.bloodtype_outlined,
                  value: formState.bloodGroup,
                  items: const ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                  onChanged: (value) =>
                      value != null ? controller.setBloodGroup(value) : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  controller: controller.heightController,
                  label: l10n.height,
                  hint: l10n.heightHint,
                  maxLength: 3,
                  icon: Icons.height_rounded,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d?$')),
                  ],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final height = double.tryParse(value.trim());
                      if (height == null) {
                        return l10n.enterValidNumber;
                      }
                      if (height <= 0 || height > 300) {
                        return l10n.enterValidHeight;
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: controller.weightController,
                  label: l10n.weight,
                  hint: l10n.weightHint,
                  maxLength: 3,
                  icon: Icons.scale_rounded,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d?$')),
                  ],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final weight = double.tryParse(value.trim());
                      if (weight == null) {
                        return l10n.enterValidNumber;
                      }
                      if (weight <= 0 || weight > 500) {
                        return l10n.enterValidWeight;
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: controller.medicalConditionsController,
            label: l10n.knownMedicalConditions,
            hint: l10n.medicalConditionsHint,
            icon: Icons.medical_information_outlined,
            maxLines: 2,
            minLines: 1,
            maxLength: 2000,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: controller.medicationsController,
            label: l10n.currentMedications,
            hint: l10n.medicationsHint,
            icon: Icons.medication_outlined,
            maxLines: 2,
            minLines: 1,
            maxLength: 3000,
          ),
        ],
      ),
    );
  }
}