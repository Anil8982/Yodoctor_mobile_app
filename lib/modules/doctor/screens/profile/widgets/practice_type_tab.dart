import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';
import 'profile_input_field.dart';

class PracticeTypeTab extends StatelessWidget {
  const PracticeTypeTab({super.key, required this.controller});
  final DoctorProfileController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: controller.practiceFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Practice Type', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.xxs),
            Text('Select your primary mode of medical practice.', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xl),

            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'Solo Practice',
                    groupValue: controller.selectedPracticeType,
                    title: Text('Solo Practice', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                    subtitle: Text('Independent clinic owner or standalone consultant', style: theme.textTheme.bodySmall),
                    activeColor: colorScheme.primary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    onChanged: (val) => controller.updatePracticeType(val!),
                  ),
                  Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                  RadioListTile<String>(
                    value: 'Hospital Affiliated',
                    groupValue: controller.selectedPracticeType,
                    title: Text('Hospital Affiliated', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                    subtitle: Text('Practicing or visiting consultant inside a corporate hospital', style: theme.textTheme.bodySmall),
                    activeColor: colorScheme.primary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    onChanged: (val) => controller.updatePracticeType(val!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            if (controller.selectedPracticeType == 'Hospital Affiliated') ...[
              ProfileInputField(
                controller: controller.hospitalNameController,
                label: 'Hospital Name',
                hint: 'Enter full name of the hospital',
                icon: Icons.corporate_fare_rounded,
              ),
            ],
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}