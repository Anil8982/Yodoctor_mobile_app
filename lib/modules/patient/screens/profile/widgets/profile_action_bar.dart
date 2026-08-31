import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/profile_image/profile_image_controller.dart';
import 'package:yodoctor/modules/patient/controllers/profile_controller.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';

class ProfileActionBar extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final String? selectedImagePath;
  final bool removeProfileImage;

  final VoidCallback onDiscardImageChanges;
  final VoidCallback onComplete;

  const ProfileActionBar({
    super.key,
    required this.formKey,
    required this.selectedImagePath,
    required this.removeProfileImage,
    required this.onDiscardImageChanges,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final profileState = ref.watch(profileControllerProvider);
    final notifier = ref.read(profileControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                notifier.discardChanges();
                onDiscardImageChanges();
                onComplete();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Discard Changes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: profileState.isLoading
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      final success = await notifier.updateProfile();

                      if (!success) {
                        if (context.mounted) {
                          final currentState = ref.read(
                            profileControllerProvider,
                          );

                          AppSnackBar.show(
                            message:
                                currentState.errorMessage ??
                                "Failed to update profile",
                            type: AppSnackBarType.error,
                          );
                        }

                        return;
                      }

                      final imageNotifier = ref.read(
                        profileImageController.notifier,
                      );

                      bool imageSuccess = true;

                      if (removeProfileImage) {
                        await imageNotifier.delete();
                      } else if (selectedImagePath != null &&
                          selectedImagePath!.isNotEmpty) {
                        final imageState = ref.read(profileImageController);

                        final hasExistingImage = imageState.value != null;

                        if (hasExistingImage) {
                          await imageNotifier.updateImage(selectedImagePath!);
                        } else {
                          await imageNotifier.upload(selectedImagePath!);
                        }
                      }

                      if (!context.mounted) return;

                      onComplete();

                      AppSnackBar.show(
                        message: "Profile Updated Successfully!",
                        type: AppSnackBarType.success,
                      );
                    },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: profileState.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Text(
                      "Save Changes",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
