import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/models/admin/admin_user.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class AdminDrawer extends ConsumerWidget {
  const AdminDrawer({super.key, required this.admin});

  final AdminUser admin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          // Header Section
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(gradient: AppTheme.adminGradient),
            accountName: Text(
              admin.name,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              admin.email,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: colorScheme.onPrimaryContainer,
              child: Icon(Icons.person, color: colorScheme.primary, size: 32),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home_rounded,
                  label: 'Home',
                  colorScheme: colorScheme,
                  onTap: () {
                    final currentRoute = GoRouterState.of(context).uri.toString();

                    Navigator.pop(context);

                    if (currentRoute != AppRoutes.adminDashboard) {
                      context.go(AppRoutes.adminDashboard);
                    }
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  label: 'Doctors Management',
                  colorScheme: colorScheme,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.doctorsManagement);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.history_rounded,
                  label: 'Enquiries',
                  colorScheme: colorScheme,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.enquiry);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.card_membership_rounded,
                  label: 'Home Care Bookings',
                  colorScheme: colorScheme,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.homeCareBooking);
                  },
                ),
                const Divider(indent: 8, endIndent: 8),

                _buildDrawerItem(
                  context,
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  colorScheme: colorScheme,
                  textColor: colorScheme.error,
                  onTap: () {
                    Navigator.pop(context);


                    ref.read(appRoleProvider.notifier).setRole(AppRole.patient);

                    context.go(AppRoutes.landing);
                  },
                ),
              ],
            ),
          ),

          // Footer / Version Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'v1.0.0',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required ColorScheme colorScheme,
        required VoidCallback onTap,
        Color? textColor,
      }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? colorScheme.onSurfaceVariant),
      title: Text(
        label,
        style: TextStyle(
          color: textColor ?? colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}