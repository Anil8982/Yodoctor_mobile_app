import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

class PatientDrawer extends StatelessWidget {
  const PatientDrawer({super.key, required this.data});

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          // Header Section
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.primary, colorScheme.primary.transparency(0.8)],
              ),
            ),
            accountName: Text(
              data.user.name,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              data.user.email,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimary.transparency(0.8),
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
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  label: 'My Profile',
                  colorScheme: colorScheme,
                  onTap: () {},
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.history_rounded,
                  label: 'Appointments',
                  colorScheme: colorScheme,
                  onTap: () {},
                ),
                const Divider(indent: 8, endIndent: 8),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  colorScheme: colorScheme,
                  textColor: colorScheme.error,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Footer / Version Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'v1.0.0',
              style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline),
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