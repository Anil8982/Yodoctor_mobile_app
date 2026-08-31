import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_profile_controller.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_multi_select_field.dart';

class ConsultationTimingsTab extends ConsumerWidget {
  const ConsultationTimingsTab({
    super.key,
    required this.controller,
    required this.autovalidateMode,
  });
  final DoctorProfileNotifier controller;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch state reactively for dynamic field updates
    final formState = ref.watch(doctorProfileProvider);

    final List<String> weekDays = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: controller.consultationFormKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consultation Settings',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Configure your consultation pricing and expected checkup time slots.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Consultation Fee (₹)',
                  isRequired: true,
                  hint: 'e.g. 500',
                  icon: Icons.currency_rupee_rounded,
                  controller: controller.feeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter fee';
                    }
                    final fee = int.tryParse(v);
                    if (fee == null || fee < 0) {
                      return 'Enter valid fee amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                AppDropdownField<int>(
                  label: 'Avg. Duration',
                  isRequired: true,
                  hint: 'Select duration',
                  icon: Icons.access_time_rounded,
                  value: formState.avgDuration,
                  items: const [10, 15, 20, 30],
                  itemLabelBuilder: (val) => '$val Mins',
                  autovalidateMode: autovalidateMode,
                  onChanged: (val) {
                    if (val != null) {
                      controller.updateDuration(val);
                    }
                  },
                  validator: (val) {
                    if (val == null) {
                      return 'Select duration';
                    }
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            AppMultiSelectField(
              label: 'Available Days',
              isRequired: true,
              hint: 'Select available days',
              icon: Icons.calendar_today_rounded,
              selectedItems: formState.activeDays,
              options: weekDays,
              autovalidateMode: autovalidateMode,
              onChanged: (selectedList) {
                for (final day in weekDays) {
                  final isCurrentlySelected = formState.activeDays.contains(
                    day,
                  );
                  final shouldBeSelected = selectedList.contains(day);
                  if (isCurrentlySelected != shouldBeSelected) {
                    controller.toggleDay(day);
                  }
                }
              },
              validator: (items) {
                if (items == null || items.isEmpty) {
                  return 'Please select at least one available day';
                }
                return null;
              },
            ),
            if (formState.availableDaysError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  'Please select at least one available day',
                  style: TextStyle(color: colorScheme.error, fontSize: 12),
                ),
              ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
