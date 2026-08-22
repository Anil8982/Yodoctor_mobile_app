import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/profile_image/profile_image_controller.dart';
import 'package:yodoctor/modules/widgets/app_drawer.dart';
import '../controllers/profile_controller.dart';
import '../../widgets/logout_dialog.dart';

class PatientDrawer extends ConsumerWidget {
  const PatientDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final profileState = ref.watch(profileControllerProvider);
    final user = profileState.user;
    final imageState = ref.watch(profileImageController);

    final String drawerName =
        (user?.fullName != null && user!.fullName.isNotEmpty)
        ? user.fullName
        : "Patient";
    final String drawerEmail = (user?.email != null && user!.email.isNotEmpty)
        ? user.email
        : "N/A";

    final currentRoute = GoRouterState.of(context).uri.path;

    return AppDrawer(
      footerText: 'YoDoctor Patient',
      headerData: DrawerHeaderData(
        title: drawerName,
        subtitle: drawerEmail,
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
          selected: currentRoute == AppRoutes.dashboard,
          onTap: () {
            Navigator.pop(context);
            context.go(AppRoutes.dashboard);
          },
        ),
        GlassDrawerItem(
          icon: Icons.person_outline_rounded,
          label: 'My Profile',
          selected: currentRoute == AppRoutes.profile,
          onTap: () {
            Navigator.pop(context);
            context.push(AppRoutes.profile);
          },
        ),
        GlassDrawerItem(
          icon: Icons.family_restroom_rounded,
          label: 'Family',
          selected: currentRoute == AppRoutes.family,
          onTap: () {
            Navigator.pop(context);
            context.push(AppRoutes.family);
          },
        ),
        GlassDrawerItem(
          icon: Icons.history_rounded,
          label: 'Appointments',
          selected: currentRoute == AppRoutes.history,
          onTap: () {
            Navigator.pop(context);
            context.go(AppRoutes.history);
          },
        ),
        GlassDrawerItem(
          icon: Icons.description_rounded,
          label: 'Certificate',
          selected: currentRoute == AppRoutes.certificateWallet,
          onTap: () {
            Navigator.pop(context);
            context.push(AppRoutes.certificateWallet);
          },
        ),
        GlassDrawerItem(
          icon: Icons.home_repair_service_rounded,
          label: 'Book Care Service',
          selected: currentRoute == AppRoutes.homeServiceBooking,
          onTap: () {
            Navigator.pop(context);
            context.push(AppRoutes.homeServiceBooking);
          },
        ),
        GlassDrawerItem(
          icon: Icons.medical_services_rounded,
          label: 'Home Care History',
          selected: currentRoute == AppRoutes.homeCareHistory,
          onTap: () {
            Navigator.pop(context);
            context.push(AppRoutes.homeCareHistory);
          },
        ),
        GlassDrawerItem(
          icon: Icons.science_rounded,
          label: 'Book Lab Test',
          selected: currentRoute == AppRoutes.labTest,
          onTap: () {
            Navigator.pop(context);
            context.push(AppRoutes.labTest);
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
            LogoutDialog.show(context, ref, role: AppRole.patient);
          },
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(ColorScheme colorScheme) {
    return Container(
      color: Colors.white.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Icon(Icons.person_rounded, color: colorScheme.onPrimary, size: 26),
    );
  }
}
