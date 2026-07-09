import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_spacing.dart';
import '../../../core/models/doctor/doctor_profile_model.dart';

class DoctorDrawer extends StatelessWidget {
  const DoctorDrawer({super.key, required this.doctor});

  final DoctorProfileModel? doctor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final String currentRoute = GoRouterState.of(context).uri.toString();
    return Drawer(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: AppTheme.doctorGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: colorScheme.onPrimary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/doctorLogo.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.medical_services_rounded,
                            color: colorScheme.onPrimary,
                            size: 30,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor?.doctorName ?? "Doctor",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          doctor?.specialization ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimary.withValues(
                              alpha: 0.82,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const _DrawerBadge(label: 'Verified Specialist'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                children: [
                  _DoctorDrawerItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    selected: currentRoute == AppRoutes.doctorDashboard,
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.doctorDashboard);
                    },
                  ),
                  _DoctorDrawerItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Doctor Profile',
                    selected:
                        currentRoute.contains('profile') ||
                        currentRoute.contains('doctorprofilesection'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(AppRoutes.doctorProfile);
                    },
                  ),
                  _DoctorDrawerItem(
                    icon: Icons.calendar_month_rounded,
                    label: 'Appointment History',
                    selected: currentRoute == AppRoutes.doctorAppointments,
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.doctorAppointments);
                    },
                  ),

                  _DoctorDrawerItem(
                    icon: Icons.book_online_rounded,
                    label: 'Manual Booking',
                    selected: currentRoute == AppRoutes.doctorManualBooking,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(AppRoutes.doctorManualBooking);
                    },
                  ),
                  _DoctorDrawerItem(
                    icon: Icons.star_outline_rounded,
                    label: 'Patient Reviews',
                    selected: currentRoute == AppRoutes.doctorReviews,
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.doctorReviews);
                    },
                  ),

                  _DoctorDrawerItem(
                    icon: Icons.card_membership_rounded,
                    label: 'Medical Certificates',
                    selected: currentRoute.contains('certificate'),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.doctorCertificates);
                    },
                  ),
                  _DoctorDrawerItem(
                    icon: Icons.workspace_premium_rounded,
                    label: 'My Subscription',
                    selected: currentRoute == AppRoutes.doctorSubscription,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(AppRoutes.doctorSubscription);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    child: Divider(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.45),
                    ),
                  ),
                  _DoctorDrawerItem(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    foregroundColor: colorScheme.error,
                    onTap: () {
                      if (context.mounted) {
                        Navigator.pop(context);
                        context.go(AppRoutes.landing);
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'yoDoctor Doctor • v1.0.0',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _showComingSoon(BuildContext context, String message) {
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text(message)));
  // }
}

class _DoctorDrawerItem extends StatelessWidget {
  const _DoctorDrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final itemColor =
        foregroundColor ??
        (selected ? colorScheme.primary : colorScheme.onSurfaceVariant);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      child: ListTile(
        onTap: onTap,
        selected: selected,
        selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: itemColor, size: 22),
        title: Text(
          label,
          style: TextStyle(
            color:
                foregroundColor ??
                (selected ? colorScheme.primary : colorScheme.onSurface),
            fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _DrawerBadge extends StatelessWidget {
  const _DrawerBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: colorScheme.onPrimary.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimary,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
