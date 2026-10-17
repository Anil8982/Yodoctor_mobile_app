import 'package:flutter/material.dart';
import 'package:yodoctor/l10n/app_localizations.dart';

import '../../../../../core/utils/app_spacing.dart';

class CertificateHeader extends StatelessWidget {
  const CertificateHeader({
    super.key,
    required this.certificateCount,
    required this.selectedFilter,
  });

  final int certificateCount;
  final String selectedFilter;

  String _getLocalizedFilter(String filter, AppLocalizations l10n) {
    switch (filter.toLowerCase()) {
      case 'pending':
        return l10n.filterPending;
      case 'approved':
        return l10n.filterApproved;
      case 'rejected':
        return l10n.filterRejected;
      case 'all':
      default:
        return l10n.filterAll;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double topPadding = MediaQuery.of(context).padding.top;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        topPadding + 60,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            l10n.medicalCertificates,
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            l10n.trackRequestsSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.onPrimary.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.workspace_premium_rounded,
                  color: colorScheme.onPrimary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.certificateCountWithFilter(
                    certificateCount,
                    _getLocalizedFilter(selectedFilter, l10n),
                  ),
                  style: textTheme.bodySmall?.copyWith(
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