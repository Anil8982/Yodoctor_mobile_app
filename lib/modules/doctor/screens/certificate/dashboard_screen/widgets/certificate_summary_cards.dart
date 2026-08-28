import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_controller.dart';

class CertificateSummaryCards extends StatelessWidget {
  const CertificateSummaryCards({
    super.key,
    required this.state,
    required this.notifier,
  });

  final CertificateState state;
  final DoctorCertificateNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final isIssuedTab = state.activeTabIndex == 1;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: isIssuedTab
            ? [
                _buildCard(
                  context,
                  'Total Issued',
                  '${notifier.issuedCount}',
                  AppTheme.info(context),
                  AppTheme.info(context),
                ),
                const SizedBox(width: AppSpacing.md),
                _buildCard(
                  context,
                  'This Month',
                  '${notifier.issuedCount}',
                  AppTheme.success(context),
                  AppTheme.success(context),
                ),
                const SizedBox(width: AppSpacing.md),
                _buildCard(
                  context,
                  'Expiring Soon',
                  '1',
                  AppTheme.error(context),
                  AppTheme.error(context),
                ),
              ]
            : [
                _buildCard(
                  context,
                  'Pending Requests',
                  '${notifier.pendingCount}',
                  AppTheme.pending(context),
                  AppTheme.pending(context),
                ),
                const SizedBox(width: AppSpacing.md),
                _buildCard(
                  context,
                  'Total Requests',
                  '${notifier.totalCount}',
                  AppTheme.info(context),
                  AppTheme.info(context),
                ),
              ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String count,
    Color textColor,
    Color containerColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: containerColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
