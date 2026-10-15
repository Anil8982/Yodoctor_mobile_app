import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yodoctor/l10n/app_localizations.dart';

import '../../../controllers/profile_controller.dart';
import 'profile_date_picker_field.dart';
import 'profile_dropdown_field.dart';
import 'profile_text_field.dart';

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

    Widget buildDivider() => Divider(
      indent: 60,
      endIndent: 20,
      thickness: 0.8,
      height: 1,
      color: colorScheme.outlineVariant.transparency(0.4),
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: colorScheme.outlineVariant.transparency(0.4)),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          children: [
            ProfileTextField(
              label: l10n.fullName,
              icon: Icons.person_rounded,
              hintText: l10n.enterFullName,
              controller: controller.nameController,
              isEditing: isEditing,
              validator: (value) {
                if (!isEditing) return null;

                if (value == null || value.trim().isEmpty) {
                  return "l10n.pleaseEnterName";
                }

                final cleanedValue = value.trim().replaceAll(
                  RegExp(r'\s+'),
                  ' ',
                );

                if (cleanedValue.length < 2) {
                  return l10n.nameMinCharacters;
                }

                if (!RegExp(
                  r'^[A-Za-z]+(?: [A-Za-z]+)*$',
                ).hasMatch(cleanedValue)) {
                  return l10n.onlyAlphabetsAllowed;
                }

                return null;
              },
            ),

            buildDivider(),

            ProfileTextField(
              label: l10n.emailAddress,
              icon: Icons.alternate_email_rounded,
              hintText: l10n.enterEmailAddress,
              controller: controller.emailController,
              isEditing: false,
            ),

            buildDivider(),

            ProfileTextField(
              label: l10n.phoneNumber,
              icon: Icons.phone_android_rounded,
              hintText: l10n.enterPhoneNumber,
              controller: controller.mobileController,
              isEditing: isEditing && controller.canEditMobile,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],

              validator: (value) {
                if (!isEditing || !controller.canEditMobile) {
                  return null;
                }

                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterPhoneNumber;
                }

                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
                  return l10n.phoneMinDigitsAllowed;
                }

                return null;
              },
            ),

            buildDivider(),

            ProfileDropdownField(
              label: l10n.gender,
              icon: Icons.wc_rounded,
              value: controller.genderController.text.toUpperCase(),
              items: const ["MALE", "FEMALE", "OTHER"],
              isEditing: isEditing,
              onChanged: (val) {
                if (val != null) {
                  controller.genderController.text = val;
                }
              },
            ),

            buildDivider(),

            ProfileDatePickerField(
              label: l10n.dateOfBirth,
              icon: Icons.cake_rounded,
              value: controller.formatDob(
                controller.dobController.text,
                context,
              ),
              isEditing: isEditing,
              onTap: () => controller.pickDateOfBirth(context),
            ),
          ],
        ),
      ),
    );
  }
}
