import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/controllers/home_care_history_controller.dart';

class HomeCareHistoryFilter extends ConsumerWidget {
  const HomeCareHistoryFilter({super.key});

  String _getFilterLabel(String filter, AppLocalizations? l10n) {
    switch (filter) {
      case 'ALL':
        return l10n?.homeCareFilterAll ?? 'ALL';
      case 'PENDING':
        return l10n?.homeCareFilterPending ?? 'PENDING';
      case 'CONFIRMED':
        return l10n?.homeCareFilterConfirmed ?? 'CONFIRMED';
      case 'COMPLETED':
        return l10n?.homeCareFilterCompleted ?? 'COMPLETED';
      case 'CANCELLED':
        return l10n?.homeCareFilterCancelled ?? 'CANCELLED';
      default:
        return filter;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(homeCareHistoryProvider);
    final notifier = ref.read(homeCareHistoryProvider.notifier);
    final l10n = AppLocalizations.of(context);

    final filters = ['ALL', 'PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED'];

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = state.selectedFilter == filter;

          return Material(
            color: AppTheme.transparent,
            child: InkWell(
              onTap: () => notifier.setFilter(filter),
              borderRadius: BorderRadius.circular(50),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.35,
                        ),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.primary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  _getFilterLabel(filter, l10n),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
