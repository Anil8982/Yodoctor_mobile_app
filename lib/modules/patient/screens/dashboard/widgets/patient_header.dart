import 'package:flutter/material.dart';

import '../../../../../core/utils/app_spacing.dart';
import '../../../../../core/widgets/gradient_background.dart';
import '../../../models/dashboard/dashboard_model.dart';

class PatientHeader extends StatelessWidget {
  const PatientHeader({super.key, required this.dashboard});

  final DashboardModel dashboard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    final String safePatientName = dashboard.patientName;

    return GradientBackground(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        topPadding + 50,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),

          Text(
            safePatientName,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  "${dashboard.upcomingCount} upcoming visits",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}