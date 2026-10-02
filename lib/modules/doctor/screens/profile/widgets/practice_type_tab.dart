import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class PracticeTypeTab extends ConsumerWidget {
  const PracticeTypeTab({
    super.key,
    required this.controller,
    required this.autovalidateMode,
  });
  final DoctorProfileNotifier controller;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formState = ref.watch(doctorProfileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: controller.practiceFormKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Practice Type',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Select your primary mode of medical practice.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.md,
                ),
                child: Column(
                  children: [
                    // 🎯 Solo Practice Row (Material 3 Compliant)
                    InkWell(
                      onTap: () =>
                          controller.updatePracticeType('Solo Practice'),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: 'Solo Practice',
                              groupValue: formState.selectedPracticeType,
                              activeColor: colorScheme.primary,
                              onChanged: (val) =>
                                  controller.updatePracticeType(val!),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Solo Practice',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Independent clinic owner or standalone consultant',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xs,
                      ),
                      child: Divider(
                        height: 1,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    ),

                    // 🎯 Hospital Affiliated Row (Material 3 Compliant)
                    InkWell(
                      onTap: () =>
                          controller.updatePracticeType('Hospital Affiliated'),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: 'Hospital Affiliated',
                              groupValue: formState.selectedPracticeType,
                              activeColor: colorScheme.primary,
                              onChanged: (val) =>
                                  controller.updatePracticeType(val!),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hospital Affiliated',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Practicing or visiting consultant inside a corporate hospital',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            if (formState.selectedPracticeType == 'Hospital Affiliated' ||
                formState.selectedPracticeType == 'Government Hospital') ...[
              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                label: 'Hospital Name',
                isRequired: true,
                hint: 'Enter full name of the hospital',
                icon: Icons.apartment_outlined,
                controller: controller.hospitalNameController,
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Hospital name required';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
