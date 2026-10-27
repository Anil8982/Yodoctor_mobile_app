import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yodoctor/core/profile_image/profile_image_controller.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import '../models/patient_model.dart';

class ProfileHeader extends ConsumerWidget {
  final PatientModel user;
  final bool isEditing;
  final String? selectedImagePath;
  final bool removeProfileImage;
  final ValueChanged<String>? onImageSelected;
  final VoidCallback? onRemoveImage;
  final VoidCallback? onEditTap;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.isEditing,
    this.selectedImagePath,
    this.removeProfileImage = false,
    this.onImageSelected,
    this.onRemoveImage,
    this.onEditTap,
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
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Change Profile Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  onImageSelected?.call(image.path);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, color: AppTheme.red),
              title: Text(
                'Remove Photo',
                style: TextStyle(color: AppTheme.red),
              ),
              onTap: () {
                Navigator.pop(context);
                onRemoveImage?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWidget(
      ColorScheme colorScheme,
      AsyncValue<String?> imageState,
      double radius,
      ) {
    return imageState.when(
      data: (url) {
        if (removeProfileImage) {
          return _buildPlaceholder(colorScheme, user, radius);
        }
        if (selectedImagePath != null && selectedImagePath!.isNotEmpty) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: FileImage(File(selectedImagePath!)),
          );
        }
        if (url != null && url.isNotEmpty) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: NetworkImage(url),
          );
        }
        return _buildPlaceholder(colorScheme, user, radius);
      },
      loading: () => CircleAvatar(
        radius: radius,
        child: const CircularProgressIndicator(strokeWidth: 2.5),
      ),
      error: (_, _) => CircleAvatar(
        radius: radius,
        child: Icon(Icons.error_outline_rounded, color: AppTheme.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageState = ref.watch(profileImageController);
    final String formattedPatientId = user.id > 0 ? '${user.id}' : 'N/A';

    // 1. In Edit Mode: Compact Centered Card with Camera Badge
    if (isEditing) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            width: 1.1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _showImageOptions(context, ref),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.35),
                        width: 2.5,
                      ),
                    ),
                    child: _buildAvatarWidget(colorScheme, imageState, 38),
                  ),
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colorScheme.surface, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to change photo',
              style: TextStyle(
                fontSize: 11.5,
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'PATIENT ID: #$formattedPatientId',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 2. In Overview Mode: Modern, Compact Horizontal Card
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: onImageSelected != null ? () => _showImageOptions(context, ref) : onEditTap,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.35),
                  width: 2.5,
                ),
              ),
              child: _buildAvatarWidget(colorScheme, imageState, 32),
            ),
          ),
          const SizedBox(width: 14),

          // Name, Email/Phone, Patient ID
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.fullName.isNotEmpty ? user.fullName : 'YoDoctor Patient',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user.email.isNotEmpty
                      ? user.email
                      : (user.phone.isNotEmpty ? user.phone : ''),
                  style: TextStyle(
                    fontSize: 11.5,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    'PATIENT ID: #$formattedPatientId',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Edit Button
          if (onEditTap != null)
            IconButton.filledTonal(
              onPressed: onEditTap,
              icon: const Icon(Icons.edit_outlined, size: 18),
              tooltip: 'Edit Profile',
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.4),
                foregroundColor: colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme, PatientModel user, double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        user.fullName.isEmpty
            ? 'P'
            : user.fullName.substring(0, 1).toUpperCase(),
        style: TextStyle(
          fontSize: radius * 0.75,
          fontWeight: FontWeight.w900,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}