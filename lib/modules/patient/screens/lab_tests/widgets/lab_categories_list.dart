import 'package:flutter/material.dart';
import 'package:yodoctor/core/models/patient/lab_test_model.dart';

import '../../../models/lab/lab_category_model.dart';

class LabCategoriesList extends StatelessWidget {
  final List<LabCategoryModel> categories;
  final int selectedCategoryId;

  final ValueChanged<int> onCategorySelected;

  const LabCategoriesList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData _getCategoryIcon(String name) {
      switch (name.toLowerCase()) {
        case "blood":
          return Icons.bloodtype;

        case "thyroid":
          return Icons.monitor_heart;

        case "diabetes":
          return Icons.medical_services;

        case "heart":
          return Icons.favorite;

        case "kidney":
          return Icons.water_drop;

        case "liver":
          return Icons.health_and_safety;

        default:
          return Icons.science;
      }
    }

    return SizedBox(
      height: 54,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat.id == selectedCategoryId;

          return Padding(
            padding: const EdgeInsets.only(right: 10, top: 4, bottom: 4),
            child: FilterChip(
              selected: isSelected,
              label: Text(cat.name),
              showCheckmark: false,
              avatar: Icon(
                _getCategoryIcon(cat.name),
                size: 16,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : colorScheme.outlineVariant,
                ),
              ),
              onSelected: (_) => onCategorySelected(cat.id),
            ),
          );
        },
      ),
    );
  }
}
