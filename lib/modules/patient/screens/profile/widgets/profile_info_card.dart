import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import '../../../controllers/profile_controller.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileController controller;
  final bool isEditing;

  const ProfileInfoCard({
    super.key,
    required this.controller,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    DateTime? selectedDob;
    if (controller.dobController.text.isNotEmpty) {
      selectedDob = DateTime.tryParse(controller.dobController.text);
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Subtitle
          Row(
            children: [
              Icon(Icons.edit_note_rounded, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'PERSONAL INFORMATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 1. Full Name (Required) using AppTextField
          AppTextField(
            label: l10n.fullName,
            isRequired: true,
            hint: l10n.enterFullName,
            icon: Icons.person_rounded,
            controller: controller.nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterName;
              }
              final cleaned = value.trim().replaceAll(RegExp(r'\s+'), ' ');
              if (cleaned.length < 2) return l10n.nameMinCharacters;
              if (!RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$').hasMatch(cleaned)) {
                return l10n.onlyAlphabetsAllowed;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 2. Email Address (Non-editable with Lock icon) using AppTextField
          AppTextField(
            label: l10n.emailAddress,
            hint: l10n.enterEmailAddress,
            icon: Icons.alternate_email_rounded,
            controller: controller.emailController,
            readOnly: true,
            enabled: false,
            suffixIcon: Icon(
              Icons.lock_outline_rounded,
              size: 18,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Mobile Number (Optional) using AppTextField
          AppTextField(
            label: l10n.phoneNumber,
            isOptional: true,
            hint: l10n.enterPhoneNumber,
            icon: Icons.phone_android_rounded,
            controller: controller.mobileController,
            readOnly: !controller.canEditMobile,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return null; // OPTIONAL
              }
              if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
                return l10n.phoneMinDigitsAllowed;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 4. Gender Dropdown using AppDropdownField
          AppDropdownField<String>(
            label: l10n.gender,
            icon: Icons.wc_rounded,
            hint: l10n.selectGender,
            value: const ['MALE', 'FEMALE', 'OTHER']
                    .contains(controller.genderController.text.toUpperCase())
                ? controller.genderController.text.toUpperCase()
                : null,
            items: const ['MALE', 'FEMALE', 'OTHER'],
            itemLabelBuilder: (item) => item,
            onChanged: (val) {
              if (val != null) {
                controller.genderController.text = val;
              }
            },
          ),
          const SizedBox(height: 16),

          // 5. Date of Birth Picker using AppDatePickerField
          AppDatePickerField(
            label: l10n.dateOfBirth,
            hint: l10n.selectDateOfBirth,
            icon: Icons.cake_rounded,
            value: selectedDob,
            firstDate: DateTime(1900),
            lastDate: DateTime.now().subtract(const Duration(days: 1)),
            onChanged: (date) {
              if (date != null) {
                controller.dobController.text = DateFormat('yyyy-MM-dd').format(date);
              } else {
                controller.dobController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
