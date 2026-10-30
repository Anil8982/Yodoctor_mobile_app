import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/core/utils/app_field_helper.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';
import 'package:yodoctor/modules/widgets/app_search_select_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class ClinicDetailsTab extends ConsumerWidget {
  const ClinicDetailsTab({
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

    // Watch provider state reactively for dynamic field integrations
    final formState = ref.watch(doctorProfileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: controller.clinicFormKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clinic Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Provide precise location and contact details for your physical clinic setup.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            AppTextField(
              label: 'Clinic Name',
              isRequired: true,
              hint: 'Enter clinic or hospital name',
              icon: Icons.business_outlined,
              controller: controller.clinicNameController,
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Clinic name required'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              label: 'Full Address',
              isRequired: true,
              hint: 'Shop/Plot no, Building name, Street...',
              icon: Icons.home_outlined,
              controller: controller.addressController,
              maxLines: 3,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Address required' : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'City',
                    isRequired: true,
                    hint: 'e.g. Nashik',
                    icon: Icons.location_city_outlined,
                    controller: controller.cityController,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'City required'
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppTextField(
                    label: 'Pincode',
                    isRequired: true,
                    hint: 'e.g. 422001',
                    icon: Icons.pin_drop_outlined,
                    controller: controller.pincodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Pincode required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              isOptional: true,
              label: 'Landmark',
              hint: 'Enter nearby landmark',
              icon: Icons.place_outlined,
              controller: controller.landmarkController,
            ),
            const SizedBox(height: AppSpacing.lg),

            AppSearchSelectField(
              label: 'State',
              icon: Icons.map_outlined,
              hint: 'eg. Madhya Pradesh',
              value: formState.selectedState.isEmpty
                  ? null
                  : formState.selectedState,
              items: indianStates,
              onChanged: (value) {
                if (value != null) {
                  controller.updateState(value);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Select state';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              isOptional: true,
              label: 'Google Maps Link',
              hint: 'Paste Google Maps location link',
              icon: Icons.location_on_outlined,
              controller: controller.mapsLinkController,
              keyboardType: TextInputType.url,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                if (!v.startsWith('http://') && !v.startsWith('https://')) {
                  return 'Enter valid URL starting with http:// or https://';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
