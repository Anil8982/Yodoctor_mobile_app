import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/profile_action_bar.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';

class PatientProfileEditScreen extends ConsumerStatefulWidget {
  const PatientProfileEditScreen({super.key});

  @override
  ConsumerState<PatientProfileEditScreen> createState() =>
      _PatientProfileEditScreenState();
}

class _PatientProfileEditScreenState
    extends ConsumerState<PatientProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedImagePath;
  bool _removeProfileImage = false;
  static const String _subTag = 'PatientProfileEditScreen';

  @override
  void initState() {
    super.initState();
    AppLogger.info(
      'PatientProfileEditScreen Initialized',
      tag: LogTags.ui,
      subTag: _subTag,
    );
  }

  void _discardAndExit() {
    ref.read(profileControllerProvider.notifier).discardChanges();
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final profileState = ref.watch(profileControllerProvider);
    final user = profileState.user;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(profileControllerProvider.notifier).discardChanges();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 1.0,
          scrolledUnderElevation: 2.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _discardAndExit,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
              if (user != null && user.id > 0)
                Text(
                  'Patient ID: #${user.id}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _discardAndExit,
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: user == null && profileState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : user == null
                ? Center(
                    child: Text(
                      profileState.errorMessage ?? 'Patient details not found',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      16,
                      AppSpacing.md,
                      32,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileHeader(
                          user: user,
                          isEditing: true,
                          selectedImagePath: _selectedImagePath,
                          removeProfileImage: _removeProfileImage,
                          onImageSelected: (path) {
                            setState(() {
                              _selectedImagePath = path;
                              _removeProfileImage = false;
                            });
                          },
                          onEditTap: null,
                          onRemoveImage: () {
                            setState(() {
                              _selectedImagePath = null;
                              _removeProfileImage = true;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Form(
                          key: _formKey,
                          child: ProfileInfoCard(
                            controller: ref.read(
                              profileControllerProvider.notifier,
                            ),
                            isEditing: true,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ProfileActionBar(
                          formKey: _formKey,
                          selectedImagePath: _selectedImagePath,
                          removeProfileImage: _removeProfileImage,
                          onDiscardImageChanges: () {
                            _discardAndExit();
                          },
                          onComplete: () {
                            if (!mounted) return;
                            context.pop();
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
