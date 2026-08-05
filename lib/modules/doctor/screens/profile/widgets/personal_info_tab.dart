import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class PersonalInfoTab extends ConsumerWidget {
  const PersonalInfoTab({
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

    // Watch current form state reactively from provider
    final formState = ref.watch(doctorProfileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: controller.personalFormKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Verify and update your basic identification details here.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            AppTextField(
              label: 'Full Name',
              isRequired: true,
              hint: 'Enter name',
              icon: Icons.person_outline_rounded,
              controller: controller.nameController,
              textCapitalization: TextCapitalization.words,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Full name required';
                if (v.trim().length < 3) return 'Enter a valid name';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              label: 'Email Address',
              hint: 'Enter email',
              enabled: false,
              icon: Icons.alternate_email_rounded,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              label: 'Mobile Number',
              isRequired: true,
              hint: 'Enter mobile',
              icon: Icons.phone_android_rounded,
              controller: controller.mobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Mobile required';
                final indianPhoneRegExp = RegExp(r'^[6-9]\d{9}$');
                if (!indianPhoneRegExp.hasMatch(v.trim())) {
                  return 'Enter a valid 10-digit mobile number';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            AppDropdownField(
              label: 'Gender',
              isRequired: true,
              hint: 'Select gender',
              icon: Icons.wc_rounded,
              value: formState.selectedGender.isEmpty
                  ? null
                  : switch (formState.selectedGender.toUpperCase()) {
                      'MALE' => 'Male',
                      'FEMALE' => 'Female',
                      'OTHER' => 'Other',
                      _ => null,
                    },
              items: const ['Male', 'Female', 'Other'],
              onChanged: (value) {
                if (value != null) {
                  controller.updateGender(value);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Select gender';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              label: 'About You',
              isRequired: true,
              hint: 'Write a brief summary about yourself...',
              icon: Icons.notes_rounded,
              controller: controller.aboutController,
              maxLines: 4,
              validator: (_) {
                final words = controller.aboutController.text
                    .trim()
                    .split(RegExp(r'\s+'))
                    .where((e) => e.isNotEmpty)
                    .length;

                if (words < 30) {
                  return 'Minimum 30 words required';
                }

                if (words > 100) {
                  return 'Maximum 100 words allowed';
                }

                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller.aboutController,
                builder: (context, value, _) {
                  final words = value.text
                      .trim()
                      .split(RegExp(r'\s+'))
                      .where((e) => e.isNotEmpty)
                      .length;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Minimum 30 words required',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '$words/100 words',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: (words < 30 || words > 100)
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                          fontWeight: (words < 30 || words > 100)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
