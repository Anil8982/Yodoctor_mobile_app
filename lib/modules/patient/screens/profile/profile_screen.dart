import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/profile_controller.dart';
import '../../../../core/utils/app_spacing.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_action_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  void toggleEdit() => setState(() => isEditing = !isEditing);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.primary,
        title: Text(
          'Profile Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ActionChip(
              onPressed: toggleEdit,
              backgroundColor: colorScheme.surface,
              side: BorderSide.none,
              avatar: Icon(
                isEditing ? Icons.visibility_outlined : Icons.edit_outlined,
                size: 18,
                color: colorScheme.primary,
              ),
              label: Text(
                isEditing ? "View" : "Edit",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),

      body: Consumer<ProfileController>(
        builder: (context, controller, child) {
          if (controller.user == null) return const Center(child: CircularProgressIndicator());

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ProfileHeader(user: controller.user!, isEditing: isEditing),
                      const SizedBox(height: 32),
                      ProfileInfoCard(controller: controller, isEditing: isEditing),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              if (isEditing)
                ProfileActionBar(
                  controller: controller,
                  onComplete: () => setState(() => isEditing = false),
                ),
            ],
          );
        },
      ),
    );
  }
}
