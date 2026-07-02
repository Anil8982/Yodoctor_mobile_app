import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/controllers/profile_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_spacing.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_action_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isEditing = false;

  void toggleEdit() => setState(() => isEditing = !isEditing);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch profile state and read notifier channel directly from Riverpod
    final profileState = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(gradient: AppTheme.patientGradient),
        ),
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
      body: Builder(
        builder: (context) {
          // Check async validation states from immutable wrapper safely
          if (profileState.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ProfileHeader(user: profileState.user!, isEditing: isEditing),
                      const SizedBox(height: 32),
                      ProfileInfoCard(controller: notifier, isEditing: isEditing),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              if (isEditing)
                ProfileActionBar(
                  controller: notifier,
                  onComplete: () => setState(() => isEditing = false),
                ),
            ],
          );
        },
      ),
    );
  }
}