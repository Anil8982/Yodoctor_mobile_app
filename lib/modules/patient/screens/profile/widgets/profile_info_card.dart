import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/modules/patient/controllers/profile_controller.dart';
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Column(
          children: [
            ProfileTextField(
              label: "Full Name",
              icon: Icons.person_rounded,
              controller: controller.nameController,
              isEditing: isEditing,
            ),
            buildDivider(),
            ProfileTextField(
              label: "Email Address",
              icon: Icons.alternate_email_rounded,
              controller: controller.emailController,
              isEditing: isEditing,
            ),
            buildDivider(),
            ProfileTextField(
              label: "Phone Number",
              icon: Icons.phone_android_rounded,
              controller: controller.mobileController,
              isEditing: isEditing,
            ),
            buildDivider(),
            ProfileTextField(
              label: "Date of Birth",
              icon: Icons.cake_rounded,
              controller: controller.dobController,
              isEditing: isEditing,
            ),
          ],
        ),
      ),
    );
  }
}