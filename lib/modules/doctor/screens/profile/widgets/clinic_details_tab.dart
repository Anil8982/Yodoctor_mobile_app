import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';
import 'profile_input_field.dart';

class ClinicDetailsTab extends ConsumerWidget {
  const ClinicDetailsTab({super.key, required this.controller});
  final DoctorProfileNotifier controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch provider state reactively for dynamic field integrations
    // final formState = ref.watch(doctorProfileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: controller.clinicFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clinic Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.xxs),
            Text('Provide precise location and contact details for your physical clinic setup.', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xl),

            ProfileInputField(
              controller: controller.clinicNameController,
              label: 'Clinic Name',
              hint: 'Enter clinic or hospital branch name',
              icon: Icons.local_hospital_outlined,
            ),
            const SizedBox(height: AppSpacing.lg),

            ProfileInputField(
              controller: controller.addressController,
              label: 'Full Address',
              hint: 'Shop/Plot no, Building name, Street...',
              icon: Icons.home_work_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.lg),

            Row(
              children: [
                Expanded(
                  child: ProfileInputField(
                    controller: controller.cityController,
                    label: 'City',
                    hint: 'e.g. Nashik',
                    icon: Icons.location_city_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ProfileInputField(
                    controller: controller.pincodeController,
                    label: 'Pincode',
                    hint: 'e.g. 422001',
                    icon: Icons.pin_drop_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            ProfileInputField(
              controller: controller.landmarkController,
              label: 'Landmark',
              hint: 'e.g. Near City Center Mall',
              icon: Icons.my_location_rounded,
            ),
            const SizedBox(height: AppSpacing.lg),

            ProfileInputField(
              controller: controller.mapsLinkController,
              label: 'Google Maps Link',
              hint: 'https://maps.google.com/?q=...',
              icon: Icons.map_outlined,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}