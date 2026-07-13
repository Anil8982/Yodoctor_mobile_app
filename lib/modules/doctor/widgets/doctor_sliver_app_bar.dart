import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';

import '../../../core/theme/app_theme.dart';

class DoctorSliverAppBar extends StatelessWidget {
  const DoctorSliverAppBar({
    super.key,
    required this.expandedHeight,
    required this.background,

    this.onProfileTap,
    this.onNotificationTap,
    this.isNavBar = true,
  });

  final double expandedHeight;
  final Widget background;

  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final bool isNavBar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      stretch: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: colorScheme.primary,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: Row(
        children: [
          _DoctorHeaderAction(
            icon: isNavBar
                ? Icons.notes_rounded
                : Icons.arrow_back_ios_new_rounded,
            onTap: () {
              if (isNavBar) {
                Scaffold.of(context).openDrawer();
              } else {
                context.pop();
              }
            },
          ),
          const Spacer(),
          _DoctorHeaderAction(
            icon: Icons.notifications_outlined,
            onTap:
                onNotificationTap ??
                () {
                  context.push(AppRoutes.notifications);
                },
          ),
          if (isNavBar) ...[
            const SizedBox(width: 12),
            _DoctorProfileAvatar(
              onTap:
                  onProfileTap ??
                  () {
                    context.push(AppRoutes.doctorProfile);
                  },
            ),
          ],
        ],
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: AppTheme.doctorGradient),
        child: FlexibleSpaceBar(
          stretchModes: const [StretchMode.zoomBackground],
          background: background,
        ),
      ),
    );
  }

  // void _showMessage(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }
}

class _DoctorHeaderAction extends StatelessWidget {
  const _DoctorHeaderAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.onPrimary.withValues(alpha: 0.08),
          ),
        ),
        child: Icon(icon, color: colorScheme.onPrimary, size: 20),
      ),
    );
  }
}

class _DoctorProfileAvatar extends StatelessWidget {
  const _DoctorProfileAvatar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.onPrimary.withValues(alpha: 0.35),
          ),
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.18),
          child: Icon(
            Icons.medical_services_rounded,
            color: colorScheme.onPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
