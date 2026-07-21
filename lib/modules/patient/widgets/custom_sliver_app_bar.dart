import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/routes/app_routes.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    required this.expandedHeight,
    required this.background,
    this.scaffoldKey,
    this.onNotificationTap,
  });

  final double expandedHeight;
  final Widget background;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: colorScheme.surface.withValues(alpha: 0),
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,

      // --- Global Sticky Header Icons ---
      title: Row(
        children: [
          // 1. Drawer/Back Button
          _buildActionButton(
            icon: Icons.notes_rounded,
            onTap: () {
              if (scaffoldKey != null) {
                scaffoldKey!.currentState?.openDrawer();
              } else {
                context.pop();
              }
            },
            colorScheme: colorScheme,
          ),
          const Spacer(),

          _buildActionButton(
            icon: Icons.notifications_outlined,
            colorScheme: colorScheme,
            onTap:
                onNotificationTap ??
                () {
                  context.push(AppRoutes.notifications);
                },
          ),
          const SizedBox(width: 12),

          // 3. Global Profile Avatar
          _buildProfileAvatar(context, colorScheme),
        ],
      ),

      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: AppTheme.patientGradient),
        child: FlexibleSpaceBar(
          stretchModes: const [StretchMode.zoomBackground],
          background: background,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.onPrimary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: colorScheme.onPrimary, size: 24),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, ColorScheme colorScheme) {
    return InkWell(
      onTap: () => context.push(AppRoutes.profile),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.onPrimary.withValues(alpha: 0.3),
          ),
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.2),
          child: Icon(
            Icons.person_rounded,
            color: colorScheme.onPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
