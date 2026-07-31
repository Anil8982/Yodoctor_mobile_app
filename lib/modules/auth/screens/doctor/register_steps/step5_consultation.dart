import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/app_text_field.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/section_label.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_card.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_title.dart';

import '../widgets/nav_buttons.dart';

class Step5Consultation extends ConsumerStatefulWidget {
  final DoctorFormData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step5Consultation({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step5Consultation> createState() => _Step5ConsultationState();
}

class _Step5ConsultationState extends ConsumerState<Step5Consultation> {
  final _formKey = GlobalKey<FormState>();
  final _feeCtrl = TextEditingController();
  bool _submittedOnce = false;

  final _days = const [
    {"label": "M", "value": "Mon"},
    {"label": "T", "value": "Tue"},
    {"label": "W", "value": "Wed"},
    {"label": "T", "value": "Thu"},
    {"label": "F", "value": "Fri"},
    {"label": "S", "value": "Sat"},
    {"label": "Su", "value": "Sun"},
  ];

  @override
  void initState() {
    super.initState();
    _feeCtrl.text = widget.data.fee;
    if (widget.data.duration.isEmpty) {
      widget.data.duration = '15 mins';
    }
  }

  @override
  void dispose() {
    _feeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime(String field) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
            primary: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;

    final formatted =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    setState(() {
      switch (field) {
        case 'morningStart':
          widget.data.morningStart = formatted;
          break;
        case 'morningEnd':
          widget.data.morningEnd = formatted;
          break;
        case 'eveningStart':
          widget.data.eveningStart = formatted;
          break;
        case 'eveningEnd':
          widget.data.eveningEnd = formatted;
          break;
      }
    });
  }

  Future<void> _handleNext() async {
    setState(() => _submittedOnce = true);

    if (!_formKey.currentState!.validate()) return;

    if (widget.data.selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one available day'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    widget.data.fee = _feeCtrl.text.trim();

    widget.data.morningEnabled =
        widget.data.morningStart.isNotEmpty && widget.data.morningEnd.isNotEmpty;

    widget.data.eveningEnabled =
        widget.data.eveningStart.isNotEmpty && widget.data.eveningEnd.isNotEmpty;

    if (!widget.data.morningEnabled && !widget.data.eveningEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please configure at least one slot timing'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final success = await ref
        .read(doctorRegisterControllerProvider.notifier)
        .saveStep5(widget.data);

    if (!mounted) return;

    if (success) {
      widget.onNext();
    } else {
      final errorMsg = ref.read(doctorRegisterControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? "Step 5 registration failed. Try again."),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final registerState = ref.watch(doctorRegisterControllerProvider);

    return Form(
      key: _formKey,
      autovalidateMode: _submittedOnce
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: StepCard(
        children: [
          StepTitle(
            icon: Icons.schedule_outlined,
            title: 'Consultation Settings',
            subtitle: 'Configure consultation fees, slot timings, and availability',
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Consultation Fee
          AppTextField(
            label: 'Consultation Fee (₹) *',
            hint: 'Enter consultation fee amount',
            icon: Icons.currency_rupee_rounded,
            controller: _feeCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Fee is required';
              final fee = int.tryParse(v);
              if (fee == null || fee < 0) return 'Enter a valid fee amount';
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Average Consultation Duration
          const SectionLabel(label: 'Average Consultation Duration', isRequired: true),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['10 mins', '15 mins', '20 mins', '30 mins'].map((duration) {
              final selected = widget.data.duration == duration;
              return GestureDetector(
                onTap: () => setState(() => widget.data.duration = duration),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? colorScheme.primaryContainer.transparency(0.85)
                        : colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant.transparency(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    duration,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Available Days of Week
          const SectionLabel(label: 'Available Days of Week', isRequired: true),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _days.map((day) {
              final selected = widget.data.selectedDays.contains(day['value']);
              return GestureDetector(
                onTap: () => setState(
                      () => selected
                      ? widget.data.selectedDays.remove(day['value'])
                      : widget.data.selectedDays.add(day['value']!),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? colorScheme.primaryContainer.transparency(0.85)
                        : colorScheme.surfaceContainerLow,
                    border: Border.all(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant.transparency(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      day['label']!,
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Morning Slot Block
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.transparency(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.primary.transparency(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.wb_sunny_rounded,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Morning Slot Timing',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _TimePickerTile(
                        label: 'Start',
                        time: widget.data.morningStart.isEmpty
                            ? '--:--'
                            : widget.data.morningStart,
                        onTap: () => _pickTime('morningStart'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TimePickerTile(
                        label: 'End',
                        time: widget.data.morningEnd.isEmpty
                            ? '--:--'
                            : widget.data.morningEnd,
                        onTap: () => _pickTime('morningEnd'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Evening Slot Block
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outlineVariant.transparency(0.5),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.nightlight_round,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Evening Slot Timing',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Optional',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _TimePickerTile(
                        label: 'Start',
                        time: widget.data.eveningStart.isEmpty
                            ? '--:--'
                            : widget.data.eveningStart,
                        onTap: () => _pickTime('eveningStart'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TimePickerTile(
                        label: 'End',
                        time: widget.data.eveningEnd.isEmpty
                            ? '--:--'
                            : widget.data.eveningEnd,
                        onTap: () => _pickTime('eveningEnd'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Action Navigation
          NavButtons(
            onBack: widget.onBack,
            onNext: registerState.isLoading ? null : _handleNext,
          ),
        ],
      ),
    );
  }
}

class _TimePickerTile extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;

  const _TimePickerTile({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.transparency(0.5),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              color: colorScheme.primary,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: time == '--:--'
                          ? colorScheme.onSurfaceVariant.transparency(0.6)
                          : colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}