import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yodoctor/core/profile_image/profile_image_controller.dart';
import '../models/patient_model.dart';

class ProfileHeader extends ConsumerWidget {
  final PatientModel user;
  final bool isEditing;
  final String? selectedImagePath;
  final bool removeProfileImage;
  final ValueChanged<String> onImageSelected;
  final VoidCallback onRemoveImage;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.isEditing,
    required this.selectedImagePath,
    required this.removeProfileImage,
    required this.onImageSelected,
    required this.onRemoveImage,
  });

  Future<void> _showImageOptions(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Change Profile Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  onImageSelected(image.path);
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Remove Photo',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                onRemoveImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final imageState = ref.watch(profileImageController);

    return Column(
      children: [
        GestureDetector(
          onTap: isEditing ? () => _showImageOptions(context, ref) : null,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 4,
                  ),
                ),
                child: imageState.when(
                  data: (url) {
                    if (removeProfileImage) {
                      return _buildPlaceholder(colorScheme, user);
                    }

                    if (selectedImagePath != null &&
                        selectedImagePath!.isNotEmpty) {
                      return CircleAvatar(
                        radius: 65,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: FileImage(File(selectedImagePath!)),
                      );
                    }

                    if (url != null && url.isNotEmpty) {
                      return CircleAvatar(
                        radius: 65,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: NetworkImage(url),
                      );
                    }

                    // 4. No image
                    return _buildPlaceholder(colorScheme, user);
                  },

                  loading: () => const CircleAvatar(
                    radius: 65,
                    child: CircularProgressIndicator(),
                  ),

                  error: (_, _) => const CircleAvatar(
                    radius: 65,
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),

              if (isEditing)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Text(
          user.fullName,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'PATIENT ID: ${user.id}',
            style: TextStyle(
              color: colorScheme.onSecondaryContainer,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme, PatientModel user) {
    return CircleAvatar(
      radius: 65,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        user.fullName.isEmpty
            ? "P"
            : user.fullName.substring(0, 1).toUpperCase(),
        style: TextStyle(
          fontSize: 52,
          fontWeight: FontWeight.w900,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
