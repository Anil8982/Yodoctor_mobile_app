import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';

import 'profile_input_field.dart';

class PersonalInfoTab extends ConsumerWidget {
  const PersonalInfoTab({super.key, required this.controller});
  final DoctorProfileNotifier controller;

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

            ProfileInputField(
              controller: controller.nameController,
              label: 'Full Name',
              hint: 'Enter name',
              icon: Icons.person_outline_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Name is required";
                }
                if (value.trim().length < 2) {
                  return "Minimum 2 characters";
                }
                if (!RegExp(r'^[A-Za-z.]+(?: [A-Za-z.]+)*$').hasMatch(value)) {
                  return 'Only alphabets are allowed';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            ProfileInputField(
              controller: controller.emailController,
              label: 'Email Address',
              hint: 'Enter email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              enabled: false,
            ),
            const SizedBox(height: AppSpacing.lg),

            ProfileInputField(
              controller: controller.mobileController,
              label: 'Mobile Number',
              hint: 'Enter mobile',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Phone number is required";
                }
                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                  return "Enter a valid phone number";
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              'Gender',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<String>(
              initialValue: formState.selectedGender.isEmpty
                  ? null
                  : switch (formState.selectedGender.toUpperCase()) {
                      'MALE' => 'Male',
                      'FEMALE' => 'Female',
                      'OTHER' => 'Other',
                      _ => null,
                    },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please select gender';
                }
                return null;
              },
              dropdownColor: colorScheme.surfaceContainerHigh,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.wc_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (val) => controller.updateGender(val!),
            ),
            const SizedBox(height: AppSpacing.lg),

            ProfileInputField(
              controller: controller.aboutController,
              label: 'About You',
              hint: 'Write a small biography...',
              icon: Icons.description_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
