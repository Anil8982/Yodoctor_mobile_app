import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_spacing.dart';

class DoctorProfileCard extends StatelessWidget {
  const DoctorProfileCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.experienceYears,
    required this.rating,
  });

  final String name;
  final String specialty;
  final int experienceYears;
  final double rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _DoctorDashboardCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.22),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/doctorLogo.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return ColoredBox(
                    color: colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusBadge(
                  label: 'VERIFIED SPECIALIST',
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  specialty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '$experienceYears yrs exp',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      child: Text(
                        '•',
                        style: TextStyle(color: colorScheme.outline),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        rating > 0 ? rating.toStringAsFixed(1) : 'N/A',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Colors.amber.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum StatType { pending, queue, completed }

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.count,
    required this.label,
    required this.badgeText,
    required this.type,
    required this.icon,
    this.isFullWidth = false, // Added to support Option 1 layout flexibility
  });

  final int count;
  final String label;
  final String badgeText;
  final StatType type;
  final IconData icon;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColors = _statColors(colorScheme);

    return _DoctorDashboardCard(
      padding: EdgeInsets.zero, // Handle padding carefully
      child: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ), // Reduced internal padding for mobile compatibility
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row optimized to handle tight widths without overflow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _IconTile(
                  icon: icon,
                  backgroundColor: statusColors.container,
                  foregroundColor: statusColors.foreground,
                ),
                // Wrap in flexible to prevent text/badge crashing into the icon
                Flexible(
                  child: _StatusBadge(
                    label: badgeText,
                    backgroundColor: statusColors.container,
                    foregroundColor: statusColors.foreground,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 14.0,
            ), // Reduced breathing room for clean fit
            // Metric display
            Text(
              count.toString(),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2.0),

            // Descriptive text label optimized for tiny sizes
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                fontSize:
                    10, // Hard limit to ensure it fits mobile screens perfectly
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _DashboardStatusColors _statColors(ColorScheme colorScheme) {
    return switch (type) {
      StatType.pending => _DashboardStatusColors(
        container: colorScheme.tertiaryContainer.transparency(0.4),
        foreground: colorScheme.tertiary,
      ),
      StatType.queue => _DashboardStatusColors(
        container: colorScheme.primaryContainer.transparency(0.4),
        foreground: colorScheme.primary,
      ),
      StatType.completed => _DashboardStatusColors(
        container: colorScheme.secondaryContainer.transparency(0.4),
        foreground: colorScheme.secondary,
      ),
    };
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _DoctorDashboardCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconTile(
            icon: icon,
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class DirectBookingCard extends StatelessWidget {
  const DirectBookingCard({super.key, required this.onShowQR});

  final VoidCallback onShowQR;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onShowQR,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorScheme.primary, colorScheme.tertiary],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.20),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Stack(
              children: [
                Positioned(
                  right: -16,
                  bottom: -18,
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: 112,
                    color: colorScheme.onPrimary.withValues(alpha: 0.10),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _IconTile(
                      icon: Icons.qr_code_scanner_rounded,
                      backgroundColor: colorScheme.onPrimary.withValues(
                        alpha: 0.16,
                      ),
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Patient Direct Booking',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Share QR code with patients for easy walk-in appointments and digital registration.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.86),
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.tonal(
                      onPressed: onShowQR,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.onPrimary,
                        foregroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      child: const Text(
                        'Show QR Code',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MiniActionCard extends StatelessWidget {
  const MiniActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.containerColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color containerColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _DoctorDashboardCard(
      onTap: onTap,
      child: SizedBox(
        height: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconTile(
              icon: icon,
              backgroundColor: containerColor,
              foregroundColor: foregroundColor,
            ),
            // const SizedBox(height: AppSpacing.xl),
            Spacer(),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorDashboardCard extends StatelessWidget {
  const _DoctorDashboardCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      shadowColor: colorScheme.shadow.withValues(alpha: 0.04),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          // minHeight: 132,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.20),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: foregroundColor, size: 22),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.55,
        ),
      ),
    );
  }
}

class _DashboardStatusColors {
  const _DashboardStatusColors({
    required this.container,
    required this.foreground,
  });

  final Color container;
  final Color foreground;
}
