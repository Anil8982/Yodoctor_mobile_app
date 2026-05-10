import 'package:flutter/material.dart';

import '../../../../../core/utils/app_spacing.dart';
import '../../../../../core/widgets/app_chip.dart';

class TrendingChips extends StatelessWidget {
  const TrendingChips({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelect,
  });

  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Trending Specialties',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: items
                  .map(
                    (String item) => AppChip(
                      label: item,
                      selected: selectedItem == item,
                      onSelected: (_) => onSelect(item),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
