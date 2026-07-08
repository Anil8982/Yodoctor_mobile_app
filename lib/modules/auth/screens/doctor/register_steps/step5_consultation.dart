import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'shared_widgets.dart';
import 'package:provider/provider.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';

class Step5Consultation extends StatefulWidget {
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
  State<Step5Consultation> createState() => _Step5ConsultationState();
}

class _Step5ConsultationState extends State<Step5Consultation> {
  final _feeCtrl = TextEditingController();
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
          colorScheme: Theme.of(
            ctx,
          ).colorScheme.copyWith(primary: AppTheme.yoBlue),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return StepCard(
      children: [
        StepTitle(
          icon: Icons.schedule_rounded,
          title: 'Consultation Settings',
          color: AppTheme.yoBlue,
        ),
        const SizedBox(height: 24),
        const SectionLabel(label: 'Consultation Fee (₹)'),
        const SizedBox(height: 10),
        TextFormField(
          controller: _feeCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'e.g. 500',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 4, top: 2),
              child: Text(
                '₹',
                style: textTheme.titleLarge?.copyWith(
                  color: AppTheme.yoBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppTheme.yoBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          onChanged: (v) => widget.data.fee = v,
        ),
        const SizedBox(height: 24),
        const SectionLabel(label: 'Average Consultation Duration'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: ['10 mins', '15 mins', '20 mins', '30 mins'].map((
            duration,
          ) {
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
                  color: selected ? AppTheme.yoBlue : colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? AppTheme.yoBlue
                        : colorScheme.outlineVariant,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  duration,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const SectionLabel(label: 'Available Days of Week'),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppTheme.yoBlue : colorScheme.surface,
                  border: Border.all(
                    color: selected
                        ? AppTheme.yoBlue
                        : colorScheme.outlineVariant,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    day['label']!,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.yoBlueLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.yoBlue.transparency(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.wb_sunny_rounded,
                    color: AppTheme.warning,
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
                  TimePickerTile(
                    label: 'Start',
                    time: widget.data.morningStart,
                    onTap: () => _pickTime('morningStart'),
                  ),
                  const SizedBox(width: 12),
                  TimePickerTile(
                    label: 'End',
                    time: widget.data.morningEnd,
                    onTap: () => _pickTime('morningEnd'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.nightlight_round,
                    color: AppTheme.yoBlue,
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
                  TimePickerTile(
                    label: 'Start',
                    time: widget.data.eveningStart.isEmpty
                        ? '--:--'
                        : widget.data.eveningStart,
                    onTap: () => _pickTime('eveningStart'),
                  ),
                  const SizedBox(width: 12),
                  TimePickerTile(
                    label: 'End',
                    time: widget.data.eveningEnd.isEmpty
                        ? '--:--'
                        : widget.data.eveningEnd,
                    onTap: () => _pickTime('eveningEnd'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        NavButtons(
          onBack: widget.onBack,
          onNext: () async {
            widget.data.fee = _feeCtrl.text;

            widget.data.morningEnabled =
                widget.data.morningStart.isNotEmpty &&
                widget.data.morningEnd.isNotEmpty;

            widget.data.eveningEnabled =
                widget.data.eveningStart.isNotEmpty &&
                widget.data.eveningEnd.isNotEmpty;

            final controller = context.read<DoctorRegisterController>();

            final ok = await controller.saveStep5(widget.data);

            if (!mounted) return;

            if (ok) {
              widget.onNext();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(controller.error ?? "Step 5 Failed")),
              );
            }
          },
        ),
      ],
    );
  }
}
