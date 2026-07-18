import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_login_controller.dart';
import 'package:yodoctor/modules/auth/repositories/patient_auth_repository.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key, required this.role});

  final AppRole role;

  static void show(BuildContext context, {required AppRole role}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => LogoutDialog(role: role),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDoctor = role == AppRole.doctor;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: colorScheme.onSurface.withValues(alpha: 0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.error.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.power_settings_new_rounded,
                      size: 36,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Ending Session?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Are you sure you want to log out? You will need to re-authenticate to access your medical dashboard.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Log Out Button
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            AppLogger.info(
                              '${isDoctor ? "Doctor" : "Patient"} confirmed logout from glassmorphic dialog gate',
                              tag: LogTags.auth,
                              subTag: 'LogoutDialog',
                            );

                            try {
                              if (isDoctor) {
                                await ref.read(doctorLoginControllerProvider.notifier).logout();
                              } else {
                                await ref.read(patientAuthRepositoryProvider).signOut();
                                await ref.read(appRoleProvider.notifier).clearRole();
                              }

                              AppLogger.success('Flushed session context. Dropping core router anchor.');

                              if (context.mounted) {
                                context.go(AppRoutes.landing);
                              }
                            } catch (e, st) {
                              AppLogger.exception(
                                e,
                                st,
                                message: 'Failed to intercept and cleanly terminate session',
                                tag: LogTags.auth,
                                subTag: 'LogoutDialog',
                              );
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.error,
                            foregroundColor: colorScheme.onError,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}