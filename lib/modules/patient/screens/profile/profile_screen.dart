import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/profile_controller.dart';
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
  static const String _subTag = 'ProfileScreen';

  void toggleEdit() {
    setState(() => isEditing = !isEditing);
    AppLogger.info('Toggle edit mode: $isEditing', tag: LogTags.ui, subTag: _subTag);
  }

  @override
  void initState() {
    super.initState();
    AppLogger.info('ProfileScreen Initialized', tag: LogTags.ui, subTag: _subTag);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final profileState = ref.watch(profileControllerProvider);

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: profileState.user == null && profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (profileState.user != null) ...[
                    ProfileHeader(
                      user: profileState.user!,
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 32),
                    ProfileInfoCard(
                      controller: ref.read(profileControllerProvider.notifier),
                      isEditing: isEditing,
                    ),
                  ] else if (profileState.errorMessage != null) ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          profileState.errorMessage!,
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          if (isEditing)
            ProfileActionBar(
              onComplete: () {
                setState(() => isEditing = false);
                AppLogger.info('Profile editing mode completed', tag: LogTags.ui, subTag: _subTag);
              },
            ),
        ],
      ),
    );
  }
}