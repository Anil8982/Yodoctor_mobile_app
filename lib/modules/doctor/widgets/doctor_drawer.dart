import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/profile_image/profile_image_controller.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/doctor/models/dashboard/doctor_profile_model.dart';
import 'package:yodoctor/modules/widgets/app_drawer.dart';
import 'package:yodoctor/modules/widgets/logout_dialog.dart';

import '../../../core/routes/app_routes.dart';

class DoctorDrawer extends ConsumerWidget {
  const DoctorDrawer({super.key, required this.doctor});

  final DoctorProfileModel? doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final imageState = ref.watch(profileImageController);

    return AppDrawer(
      footerText: 'YoDoctor Doctor',
      headerData: DrawerHeaderData(
        title: doctor?.doctorName ?? "Doctor",
        subtitle: doctor?.specialization ?? "",
        badge: const GlassBadge(label: 'Verified Specialist'),
        avatarChild: imageState.when(
          data: (imageUrl) {
            if (imageUrl != null && imageUrl.isNotEmpty) {
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultAvatar(colorScheme),
              );
            }
            return _buildDefaultAvatar(colorScheme);
          },
          loading: () => Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          error: (_, _) => _buildDefaultAvatar(colorScheme),
        ),
      ),
      items: [
        GlassDrawerItem(
          icon: Icons.home_rounded,
          label: 'Home',
          selected: currentRoute == AppRoutes.doctorDashboard,
          onTap: () {
            Navigator.pop(context);
            context.go(AppRoutes.doctorDashboard);
          },
        ),
        GlassDrawerItem(
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
        GlassDrawerItem(
          icon: Icons.calendar_month_rounded,
          label: 'Appointment History',
          selected: currentRoute == AppRoutes.doctorAppointments,
          onTap: () {
            Navigator.pop(context);
            context.go(AppRoutes.doctorAppointments);
          },
        ),
        GlassDrawerItem(
          icon: Icons.book_online_rounded,
          label: 'Manual Booking',
          selected: currentRoute == AppRoutes.doctorManualBooking,
          onTap: () {
            Navigator.pop(context);
            context.go(AppRoutes.doctorManualBooking);
          },
        ),
        GlassDrawerItem(
          icon: Icons.star_outline_rounded,
          label: 'Patient Reviews',
          selected: currentRoute == AppRoutes.doctorReviews,
          onTap: () {
            Navigator.pop(context);
            context.push(AppRoutes.doctorReviews);
          },
        ),
        GlassDrawerItem(
          icon: Icons.card_membership_rounded,
          label: 'Medical Certificates',
          selected: currentRoute.contains('certificate'),
          onTap: () {
            Navigator.pop(context);
            context.go(AppRoutes.doctorCertificates);
          },
        ),
        GlassDrawerItem(
          icon: Icons.workspace_premium_rounded,
          label: 'My Subscription',
          selected: currentRoute == AppRoutes.doctorSubscription,
          onTap: () {
            Navigator.pop(context);
            context.push(AppRoutes.doctorSubscription);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            height: 1,
          ),
        ),
        GlassDrawerItem(
          icon: Icons.logout_rounded,
          label: 'Logout',
          foregroundColor: colorScheme.error,
          onTap: () {
            Navigator.pop(context);
            LogoutDialog.show(context, ref, role: AppRole.doctor);
          },
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(ColorScheme colorScheme) {
    return Container(
      color: AppTheme.white.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Icon(
        Icons.medical_services_rounded,
        color: colorScheme.onPrimary,
        size: 26,
      ),
    );
  }
}
