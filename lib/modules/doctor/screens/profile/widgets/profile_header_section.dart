import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yodoctor/core/profile_image/profile_image_controller.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';

class ProfileHeaderSection extends ConsumerWidget {
  const ProfileHeaderSection({
    super.key,
    this.isEditMode = false,
    this.doctor,
  });

  final bool isEditMode;
  final dynamic doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formState = ref.watch(doctorProfileProvider);
    final imageState = ref.watch(profileImageController);

    final String displayName = isEditMode
        ? (formState.profile?.doctorName ?? "Doctor Name")
        : (doctor?.doctorName ?? "Doctor Name");

    final String displaySpecialization = isEditMode
        ? (formState.profile?.specialization ?? "Specialization")
        : (doctor?.specialization ?? "Specialization");

    final String displayTag = isEditMode
        ? 'ID: ${formState.profile?.id ?? 'PENDING'}'
        : (doctor?.degree ?? '');

    void showImagePreview(BuildContext context, String? imageUrl) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 500),
                  color: colorScheme.surface,
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _buildLargeFallbackAvatar(colorScheme),
                  )
                      : _buildLargeFallbackAvatar(colorScheme),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Future<void> showImageOptions(BuildContext context) async {
      final ImagePicker picker = ImagePicker();
      showModalBottomSheet(
        context: context,
        backgroundColor: colorScheme.surface,
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
                    final notifier = ref.read(profileImageController.notifier);
                    final hasImage =
                        ref.read(profileImageController).value != null;
                    if (hasImage) {
                      await notifier.updateImage(image.path);
                    } else {
                      await notifier.upload(image.path);
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await ref.read(profileImageController.notifier).delete();
                },
              ),
            ],
          ),
        ),
      );
    }

    // करंट इमेज URL मिळवण्यासाठी
    final currentImageUrl = imageState.value;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        kToolbarHeight + AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isEditMode ? () => showImageOptions(context) : null,
            onLongPress: () => showImagePreview(context, currentImageUrl),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.onPrimary.withValues(alpha: 0.25),
                      width: 2.5,
                    ),
                  ),
                  child: imageState.when(
                    data: (imageUrl) {
                      if (imageUrl != null && imageUrl.isNotEmpty) {
                        return CircleAvatar(
                          radius: 36,
                          backgroundColor: colorScheme.onPrimary.withValues(
                            alpha: 0.12,
                          ),
                          backgroundImage: NetworkImage(imageUrl),
                        );
                      }
                      return _buildDefaultAvatar(colorScheme);
                    },
                    loading: () => const CircleAvatar(
                      radius: 36,
                      child: CircularProgressIndicator(),
                    ),
                    error: (_, _) => _buildDefaultAvatar(colorScheme),
                  ),
                ),
                if (isEditMode)
                  InkWell(
                    onTap: () => showImageOptions(context),
                    borderRadius: BorderRadius.circular(100),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: colorScheme.surface,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 11,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displaySpecialization,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (displayTag.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.onPrimary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      displayTag,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(ColorScheme colorScheme) {
    return CircleAvatar(
      radius: 36,
      backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.12),
      child: Icon(
        Icons.person_rounded,
        color: colorScheme.onPrimary,
        size: 38,
      ),
    );
  }

  Widget _buildLargeFallbackAvatar(ColorScheme colorScheme) {
    return Container(
      width: 200,
      height: 200,
      alignment: Alignment.center,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person_rounded,
        color: colorScheme.onSurfaceVariant,
        size: 100,
      ),
    );
  }
}