import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/core/utils/responsive.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_controller.dart';

class CertificateToolbar extends StatelessWidget {
  const CertificateToolbar({
    super.key,
    required this.searchController,
    required this.state,
    required this.notifier,
  });

  final TextEditingController searchController;
  final CertificateState state;
  final DoctorCertificateNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = Responsive.isMobile(context);

    final searchField = TextField(
      controller: searchController,
      onChanged: notifier.updateSearchQuery,
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: 'Search patient or ID...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colorScheme.primary,
          size: 20,
        ),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );

    final dropdownDecoration = InputDecoration(
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
    );

    final typeDropdown = DropdownButtonFormField<String>(
      initialValue: state.selectedTypeFilter,
      isExpanded: true,
      decoration: dropdownDecoration,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      dropdownColor: colorScheme.surface,
      items: const [
        DropdownMenuItem(value: 'All Types', child: Text('All Types')),
        DropdownMenuItem(
          value: 'Medical Fitness',
          child: Text('Medical Fitness'),
        ),
        DropdownMenuItem(value: 'Vaccination', child: Text('Vaccination')),
      ],
      onChanged: (val) => notifier.updateTypeFilter(val!),
    );

    final statusDropdown = DropdownButtonFormField<String>(
      initialValue: state.selectedStatusFilter,
      decoration: dropdownDecoration,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      dropdownColor: colorScheme.surface,
      items: const [
        DropdownMenuItem(value: "All Status", child: Text("All Status")),
        DropdownMenuItem(value: "PENDING", child: Text("Pending")),
        DropdownMenuItem(value: "APPROVED", child: Text("Approved")),
        DropdownMenuItem(value: "REJECTED", child: Text("Rejected")),
      ],
      onChanged: (val) => notifier.updateStatusFilter(val!),
    );

    if (isMobile) {
      return Column(
        children: [
          searchField,
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: typeDropdown),
              if (state.activeTabIndex == 0) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: statusDropdown),
              ],
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        SizedBox(width: 280, child: searchField),
        const SizedBox(width: AppSpacing.md),
        SizedBox(width: 180, child: typeDropdown),
        if (state.activeTabIndex == 0) ...[
          const SizedBox(width: AppSpacing.md),
          SizedBox(width: 170, child: statusDropdown),
        ],
      ],
    );
  }
}