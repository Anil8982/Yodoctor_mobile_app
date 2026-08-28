import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              label: "Full Name",
              icon: Icons.person_rounded,
              controller: controller.nameController,
              isEditing: isEditing,
              validator: (value) {
                if (!isEditing) return null;

                if (value == null || value.trim().isEmpty) {
                  return "Enter name";
                }

                if (value.trim().length < 2) {
                  return "Name should have at least 2 characters";
                }
                if (!RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$').hasMatch(value)) {
                  return 'Only alphabets are allowed';
                }

                return null;
              },
            ),

            buildDivider(),

            ProfileTextField(
              label: "Email Address",
              icon: Icons.alternate_email_rounded,
              controller: controller.emailController,
              isEditing: false,
            ),

            buildDivider(),

            ProfileTextField(
              label: "Phone Number",
              icon: Icons.phone_android_rounded,
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
                  return "Enter phone number";
                }

                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
                  return "Enter a valid 10-digit mobile number";
                }

                return null;
              },
            ),

            buildDivider(),

            ProfileDropdownField(
              label: "GENDER",
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
              label: "Date of Birth",
              icon: Icons.cake_rounded,
              value: controller.formatDob(controller.dobController.text),
              isEditing: isEditing,
              onTap: () => controller.pickDateOfBirth(context),
            ),
          ],
        ),
      ),
    );
  }
}
