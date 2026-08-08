import 'package:flutter/material.dart';

class DrawerHeaderData {
  final String title;
  final String subtitle;
  final Widget? badge;
  final Widget avatarChild;

  const DrawerHeaderData({
    required this.title,
    required this.subtitle,
    this.badge,
    required this.avatarChild,
  });
}

class DrawerItemData {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? foregroundColor;

  const DrawerItemData({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.foregroundColor,
  });
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.headerData,
    required this.items,
    required this.footerText,
  });

  final DrawerHeaderData headerData;
  final List<Widget> items;
  final String footerText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Section
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: headerData.avatarChild,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          headerData.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          headerData.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimary.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        if (headerData.badge != null) ...[
                          const SizedBox(height: 6),
                          headerData.badge!,
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                children: items,
              ),
            ),

            // Footer Version Tag
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 30),
              child: Text(
                footerText,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GlassDrawerItem extends StatelessWidget {
  const GlassDrawerItem({
    super.key,
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
    final itemColor = foregroundColor ??
        (selected ? colorScheme.primary : colorScheme.onSurfaceVariant);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primaryContainer.withValues(alpha: 0.4)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: selected
            ? Border.all(color: colorScheme.primary.withValues(alpha: 0.2), width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: Icon(icon, color: itemColor, size: 20),
          title: Text(
            label,
            style: TextStyle(
              color: foregroundColor ??
                  (selected ? colorScheme.primary : colorScheme.onSurface),
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
        ),
      ),
    );
  }
}

class GlassBadge extends StatelessWidget {
  const GlassBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}