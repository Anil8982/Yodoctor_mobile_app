import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';
import 'profile_input_field.dart';

class ConsultationTimingsTab extends ConsumerWidget {
  const ConsultationTimingsTab({super.key, required this.controller});
  final DoctorProfileNotifier controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch state reactively for dynamic field updates
    final formState = ref.watch(doctorProfileProvider);

    final List<String> weekDays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: controller.consultationFormKey,
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
                    controller: controller.feeController,
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
                        initialValue: formState.avgDuration,
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
                          // TODO: Implement duration update logic inside notifier if needed
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
              children: weekDays.map((day) {
                final isSelected = formState.activeDays.contains(day);
                return FilterChip(
                  label: Text(day, style: TextStyle(fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600)),
                  selected: isSelected,
                  selectedColor: colorScheme.primaryContainer,
                  checkmarkColor: colorScheme.onPrimaryContainer,
                  labelStyle: TextStyle(color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (selected) {
                    // TODO: Implement toggle functionality inside profile state structure
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