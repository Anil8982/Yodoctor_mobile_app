import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class ProfessionalInfoTab extends StatelessWidget {
  const ProfessionalInfoTab({
    super.key,
    required this.controller,
    required this.autovalidateMode,
  });
  final DoctorProfileNotifier controller;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: controller.professionalFormKey,
        autovalidateMode: autovalidateMode,
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

            AppDropdownField<String>(
              label: 'Primary Qualification',
              isRequired: true,
              hint: 'e.g. MBBS, MD, MS',
              icon: Icons.school_outlined,
              value: controller.qualificationController.text.isEmpty
                  ? null
                  : controller.qualificationController.text,
              items: const [
                'MBBS',
                'MD',
                'MS',
                'BDS',
                'MDS',
                'BAMS',
                'BHMS',
                'Other',
              ],
              onChanged: (value) {
                controller.qualificationController.text = value ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Select qualification';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              label: 'Specialization',
              isRequired: true,
              hint: 'e.g. Cardiologist, Dermatologist',
              icon: Icons.local_hospital_outlined,
              controller: controller.specializationController,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Specialization required'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Years of Experience',
              isRequired: true,
              hint: 'e.g. 8',
              icon: Icons.workspace_premium_outlined,
              controller: controller.expController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Experience required';
                final exp = int.tryParse(v);
                if (exp == null || exp > 60) return 'Enter valid experience';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              label: 'Medical Registration Number',
              isRequired: true,
              hint: 'e.g., MMC/2018/12345 or MCI-12345',
              icon: Icons.badge_outlined,
              controller: controller.regNoController,
              maxLength: 25,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => TextEditingValue(
                    text: newValue.text.toUpperCase(),
                    selection: newValue.selection,
                  ),
                ),
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9/-]')),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Registration no. required';
                }
                final cleaned = v.trim();
                if (cleaned.length < 4) {
                  return 'Registration no. too short';
                }
                if (cleaned.length > 25) {
                  return 'Registration no. cannot exceed 25 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              label: 'State Medical Council',
              isRequired: true,
              hint: 'e.g. Maharashtra Medical Council',
              icon: Icons.account_balance_outlined,
              controller: controller.councilController,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'State council required'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            AppDatePickerField(
              label: 'Registration Valid Till',
              isRequired: true,
              hint: 'Select expiry date',
              icon: Icons.calendar_today_rounded,

              value: controller.regValidTillController.text.isEmpty
                  ? null
                  : DateFormat(
                      'dd MMM yyyy',
                    ).parse(controller.regValidTillController.text),

              firstDate: DateTime.now(),
              lastDate: DateTime(2045),

              onChanged: (date) {
                if (date == null) return;
                controller.regValidTillController.text = DateFormat(
                  'dd MMM yyyy',
                ).format(date);
              },

              validator: (date) {
                if (date == null) {
                  return 'Registration validity date required';
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
