import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import '../models/dashboard/dashboard_model.dart';

class PatientDrawer extends StatelessWidget {
  const PatientDrawer({super.key, this.dashboard});

  final DashboardModel? dashboard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(gradient: AppTheme.patientGradient),

            accountName: Text(
              dashboard?.patient.name ?? "Patient",
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            accountEmail: Text(
              dashboard?.patient.email ?? "",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: .8),
              ),
            ),

            currentAccountPicture: CircleAvatar(
              backgroundColor: colorScheme.onPrimaryContainer,
              backgroundImage:
                  dashboard?.patient.image != null &&
                      dashboard!.patient.image!.isNotEmpty
                  ? NetworkImage(dashboard!.patient.image!)
                  : null,
              child:
                  (dashboard?.patient.image == null ||
                      dashboard!.patient.image!.isEmpty)
                  ? Icon(Icons.person, color: colorScheme.primary, size: 32)
                  : null,
            ),
          ),

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
                    Navigator.pop(context);
                    context.go(AppRoutes.dashboard);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  label: 'My Profile',
                  colorScheme: colorScheme,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.profile);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.history_rounded,
                  label: 'Appointments',
                  colorScheme: colorScheme,
                  onTap: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.history);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.description_rounded,
                  label: 'Certificate',
                  colorScheme: colorScheme,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.certificateWallet);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.home_repair_service_rounded,
                  label: 'Book Nurse',
                  colorScheme: colorScheme,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.homeServiceBooking);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.science_rounded,
                  label: 'Book Lab Test',
                  colorScheme: colorScheme,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.labTest);
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
            padding: const EdgeInsets.all(16),
            child: Text(
              "v1.0.0",
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
