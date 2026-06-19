import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/core/utils/responsive.dart';
import '../../../controllers/appointment_history_controller.dart';

class HistoryToolbar extends StatelessWidget {
  const HistoryToolbar({
    super.key,
    required this.selectedFilter,
    required this.searchController,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  final DoctorAppointmentFilter selectedFilter;
  final TextEditingController searchController;
  final ValueChanged<DoctorAppointmentFilter> onFilterChanged;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final filterBar = SegmentedButton<DoctorAppointmentFilter>(
      segments: const [
        ButtonSegment(value: DoctorAppointmentFilter.today, label: Text('Today')),
        ButtonSegment(value: DoctorAppointmentFilter.lastSevenDays, label: Text('Last 7 Days')),
        ButtonSegment(value: DoctorAppointmentFilter.all, label: Text('All')),
      ],
      selected: {selectedFilter},
      showSelectedIcon: false,
      onSelectionChanged: (selection) => onFilterChanged(selection.first),
    );

    final searchField = TextField(
      controller: searchController,
      onChanged: onSearchChanged,
      decoration: const InputDecoration(
        hintText: 'Search patient...',
        prefixIcon: Icon(Icons.search_rounded),
      ),
    );

    if (Responsive.isMobile(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: filterBar,
          ),
          const SizedBox(height: AppSpacing.sm),
          searchField,
        ],
      );
    }

    return Row(
      children: [
        filterBar,
        const SizedBox(width: AppSpacing.md),
        SizedBox(width: 330, child: searchField),
      ],
    );
  }
}