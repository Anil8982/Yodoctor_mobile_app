import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';
import 'profile_input_field.dart';

class ConsultationTimingsTab extends StatefulWidget {
  const ConsultationTimingsTab({super.key, required this.controller});
  final DoctorProfileController controller;

  @override
  State<ConsultationTimingsTab> createState() => _ConsultationTimingsTabState();
}

class _ConsultationTimingsTabState extends State<ConsultationTimingsTab> {
  final List<String> _weekDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: widget.controller.consultationFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consultation Settings', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.xxs),
            Text('Configure your consultation pricing and expected checkup time slots.', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xl),

            Row(
              children: [
                Expanded(
                  child: ProfileInputField(
                    controller: widget.controller.feeController,
                    label: 'Consultation Fee (₹)',
                    hint: 'e.g. 500',
                    icon: Icons.currency_rupee_rounded,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avg. Duration',
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      DropdownButtonFormField<int>(
                        initialValue: widget.controller.avgDuration,
                        dropdownColor: colorScheme.surfaceContainerHigh,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.onSurfaceVariant),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.access_time_rounded, color: colorScheme.primary, size: 20),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHigh,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                        items: const [
                          DropdownMenuItem(value: 10, child: Text('10 Mins')),
                          DropdownMenuItem(value: 15, child: Text('15 Mins')),
                          DropdownMenuItem(value: 20, child: Text('20 Mins')),
                          DropdownMenuItem(value: 30, child: Text('30 Mins')),
                        ],
                        onChanged: (val) {
                          setState(() {
                            widget.controller.avgDuration = val!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            Text('Available Days', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: _weekDays.map((day) {
                final isSelected = widget.controller.activeDays.contains(day);
                return FilterChip(
                  label: Text(day, style: TextStyle(fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600)),
                  selected: isSelected,
                  selectedColor: colorScheme.primaryContainer,
                  checkmarkColor: colorScheme.onPrimaryContainer,
                  labelStyle: TextStyle(color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        widget.controller.activeDays.add(day);
                      } else {
                        widget.controller.activeDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}