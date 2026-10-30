import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class MedicineItemControllers {
  final TextEditingController name;
  final TextEditingController dosage;
  final TextEditingController frequency;
  final TextEditingController duration;
  final TextEditingController instructions;
  bool isExpanded;

  MedicineItemControllers({
    String name = '',
    String dosage = '',
    String frequency = '',
    String duration = '',
    String instructions = '',
    this.isExpanded = true,
  })  : name = TextEditingController(text: name),
        dosage = TextEditingController(text: dosage),
        frequency = TextEditingController(text: frequency),
        duration = TextEditingController(text: duration),
        instructions = TextEditingController(text: instructions);

  void dispose() {
    name.dispose();
    dosage.dispose();
    frequency.dispose();
    duration.dispose();
    instructions.dispose();
  }
}

class PrescriptionMedicineCard extends StatelessWidget {
  final int index;
  final MedicineItemControllers item;
  final bool isBusy;
  final VoidCallback onToggleExpand;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const PrescriptionMedicineCard({
    super.key,
    required this.index,
    required this.item,
    required this.isBusy,
    required this.onToggleExpand,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final medicineName = item.name.text.trim();
    final medicineTitle = medicineName.isNotEmpty
        ? medicineName
        : "Medicine #${index + 1} (Empty)";

    final subtitleParts = [
      if (item.dosage.text.trim().isNotEmpty) item.dosage.text.trim(),
      if (item.frequency.text.trim().isNotEmpty) item.frequency.text.trim(),
      if (item.duration.text.trim().isNotEmpty) item.duration.text.trim(),
    ].join(' • ');

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isExpanded
              ? colorScheme.primary.transparency(0.35)
              : colorScheme.outlineVariant.transparency(0.4),
          width: item.isExpanded ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(16),
              bottom: Radius.circular(item.isExpanded ? 0 : 16),
            ),
            onTap: onToggleExpand,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 10,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: medicineName.isNotEmpty
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    child: Text(
                      "${index + 1}",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: medicineName.isNotEmpty
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicineTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: medicineName.isNotEmpty
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitleParts.isNotEmpty && !item.isExpanded) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitleParts,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: isBusy ? null : onRemove,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: colorScheme.error,
                    ),
                    tooltip: "Remove medicine",
                  ),
                  Icon(
                    item.isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (item.isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: "Medicine Name",
                    hint: "e.g., Paracetamol, Cetirizine",
                    icon: Icons.medication_outlined,
                    controller: item.name,
                    enabled: !isBusy,
                    onChanged: (_) => onChanged(),
                    validator: (value) {
                      final hasOtherFields =
                          item.dosage.text.trim().isNotEmpty ||
                              item.frequency.text.trim().isNotEmpty ||
                              item.duration.text.trim().isNotEmpty ||
                              item.instructions.text.trim().isNotEmpty;
                      if (hasOtherFields &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Medicine name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 520;
                      final dosageField = AppTextField(
                        label: "Dosage",
                        hint: "e.g., 500 mg",
                        icon: Icons.scale_outlined,
                        controller: item.dosage,
                        enabled: !isBusy,
                        onChanged: (_) => onChanged(),
                      );
                      final frequencyField = AppTextField(
                        label: "Frequency",
                        hint: "e.g., Twice daily",
                        icon: Icons.repeat_rounded,
                        controller: item.frequency,
                        enabled: !isBusy,
                        onChanged: (_) => onChanged(),
                      );
                      final durationField = AppTextField(
                        label: "Duration",
                        hint: "e.g., 3 days",
                        icon: Icons.timelapse_outlined,
                        controller: item.duration,
                        enabled: !isBusy,
                        onChanged: (_) => onChanged(),
                      );

                      if (isWide) {
                        return Row(
                          children: [
                            Expanded(child: dosageField),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: frequencyField),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: durationField),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          dosageField,
                          const SizedBox(height: AppSpacing.sm),
                          frequencyField,
                          const SizedBox(height: AppSpacing.sm),
                          durationField,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: "Instructions",
                    hint: "e.g., After food, At night",
                    icon: Icons.info_outline,
                    controller: item.instructions,
                    enabled: !isBusy,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}