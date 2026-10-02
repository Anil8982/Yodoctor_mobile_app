import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/core/utils/responsive.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';

class AutoHideSpecialtyFilter extends StatelessWidget {
  final List<String> specialties;
  final String? selectedSpecialty;
  final ValueChanged<String> onSpecialtySelected;

  const AutoHideSpecialtyFilter({
    super.key,
    required this.specialties,
    required this.selectedSpecialty,
    required this.onSpecialtySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final horizontalPadding = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    final specialtyItems = <String>['All Specialties', ...specialties];
    final currentValue = selectedSpecialty == null || selectedSpecialty!.isEmpty
        ? 'All Specialties'
        : selectedSpecialty!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isMobile ? double.infinity : 300,
            child: AppDropdownField(
              label: 'Featured Specialties',
              labelStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
              hint: 'Select Specialty',
              icon: Icons.filter_alt_rounded,
              value: currentValue,
              items: specialtyItems,
              isRequired: false,
              onChanged: (value) {
                if (value == null) return;

                final newSpecialty = value == 'All Specialties' ? '' : value;
                final oldSpecialty = selectedSpecialty ?? '';

                // Only trigger search if specialty actually changed
                if (newSpecialty != oldSpecialty) {
                  onSpecialtySelected(newSpecialty);
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Available Doctors',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}