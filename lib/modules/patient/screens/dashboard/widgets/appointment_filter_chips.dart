import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_chip.dart';

class AppointmentFilterChips extends StatelessWidget {
  const AppointmentFilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (String filter) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AppChip(
                  label: filter,
                  selected: selectedFilter == filter,
                  onSelected: (_) => onFilterSelected(filter),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
