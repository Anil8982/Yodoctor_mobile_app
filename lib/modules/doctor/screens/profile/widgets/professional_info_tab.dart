import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';

import 'profile_input_field.dart';

class ProfessionalInfoTab extends StatelessWidget {
  const ProfessionalInfoTab({super.key, required this.controller});
  final DoctorProfileNotifier controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: controller.professionalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Professional Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Update your medical qualifications and registration compliance details.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            ProfileInputField(
              controller: controller.qualificationController,
              label: 'Primary Qualification',
              hint: 'e.g. MBBS, MD, MS',
              icon: Icons.school_outlined,
              validator: (value) {
                if (!RegExp(r'^[A-Za-z.\s]{2,80}$').hasMatch(value!.trim())) {
                  return "Enter a valid qualification";
                }

                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            ProfileInputField(
              controller: controller.specializationController,
              label: 'Specialization',
              hint: 'e.g. Cardiologist, Dermatologist',
              icon: Icons.biotech_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Select specialization";
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            ProfileInputField(
              controller: controller.expController,
              label: 'Years of Experience',
              hint: 'e.g. 8',
              icon: Icons.hourglass_empty_rounded,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.lg),

            ProfileInputField(
              controller: controller.regNoController,
              label: 'Medical Registration Number',
              hint: 'Enter your medical council reg no.',
              icon: Icons.assignment_ind_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Enter registration number";
                }

                if (!RegExp(r'^[A-Za-z0-9/-]{5,25}$').hasMatch(value.trim())) {
                  return "Invalid registration number";
                }

                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            ProfileInputField(
              controller: controller.councilController,
              label: 'State Medical Council',
              hint: 'e.g. Maharashtra Medical Council',
              icon: Icons.account_balance_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Select medical council";
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            GestureDetector(
              onTap: () => controller.pickRegistrationValidTill(context),
              child: AbsorbPointer(
                child: ProfileInputField(
                  controller: controller.regValidTillController,
                  label: 'Registration Valid Till',
                  hint: 'DD/MM/YYYY',
                  icon: Icons.calendar_today_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Select registration validity date";
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
