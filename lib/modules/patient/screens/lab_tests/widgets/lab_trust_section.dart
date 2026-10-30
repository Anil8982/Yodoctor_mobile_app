import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/l10n/app_localizations.dart';

class LabTrustSection extends StatelessWidget {
  const LabTrustSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.gavel_rounded,
        'title': l10n?.lowestPrices ?? 'Lowest Prices',
        'desc': l10n?.transparentDesc ?? 'Transparent',
      },
      {
        'icon': Icons.home_max_rounded,
        'title': l10n?.homeCollectionShort ?? 'Home Coll.',
        'desc': l10n?.sevenDaysAWeek ?? '7 days/week',
      },
      {
        'icon': Icons.assignment_turned_in_rounded,
        'title': l10n?.accurateTitle ?? 'Accurate',
        'desc': l10n?.verifiedDesc ?? 'Verified',
      },
      {
        'icon': Icons.lock_outline_rounded,
        'title': l10n?.hundredPercentPrivate ?? '100% Private',
        'desc': l10n?.encryptedDesc ?? 'Encrypted',
      },
    ];

    return SizedBox(
      height: 60,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Icon(item['icon'] as IconData, color: AppTheme.warning(context), size: 20),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      item['desc'] as String,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}