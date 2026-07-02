import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key, required this.controller});
  final DoctorProfileNotifier controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Access state data structure from manual notifier
    final formState = controller.state;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        kToolbarHeight + AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Stack(
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
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Image.asset(
                      'assets/images/doctorLogo.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.medical_services_rounded,
                        color: colorScheme.onPrimary,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: Wire up image picker session logic
                },
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
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.nameController.text.isNotEmpty
                      ? controller.nameController.text
                      : 'Doctor Name',
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
                  controller.specializationController.text.isNotEmpty
                      ? controller.specializationController.text
                      : 'Specialization',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                    'ID: ${formState.profile?.id ?? 'PENDING'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}