import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'nav_buttons.dart';
import 'shared_widgets.dart';

class Step4Practice extends ConsumerStatefulWidget {
  final DoctorFormData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step4Practice({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step4Practice> createState() => _Step4PracticeState();
}

class _Step4PracticeState extends ConsumerState<Step4Practice> {
  final _hospCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Added missing form key mapping for verification

  final _options = const [
    {'title': 'Solo Practice', 'desc': 'Private clinic owned by you'},
    {
      'title': 'Multi-Speciality Clinic',
      'desc': 'Shared practice with multiple doctors',
    },
    {
      'title': 'Hospital Attached',
      'desc': 'Located within a hospital premises',
    },
    {'title': 'Visiting Consultant', 'desc': 'Consulting at various locations'},
    {
      'title': 'Government Hospital',
      'desc': 'Practicing in a public health facility',
    },
  ];

  @override
  void initState() {
    super.initState();
    _hospCtrl.text = widget.data.hospitalName;
  }

  @override
  void dispose() {
    _hospCtrl.dispose();
    super.dispose();
  }

  bool get _hospRequired =>
      widget.data.practiceType == 'Hospital Attached' ||
          widget.data.practiceType == 'Government Hospital';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final registerState = ref.watch(doctorRegisterControllerProvider);

    return Form(
      key: _formKey,
      child: StepCard(
        children: [
          StepTitle(
            icon: Icons.business_center_rounded,
            title: 'Practice Type',
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),
          ..._options.map((opt) {
            final selected = widget.data.practiceType == opt['title'];
            return GestureDetector(
              onTap: () => setState(() => widget.data.practiceType = opt['title']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // 🎯 FIXED BY CHROMA_KIT: Balanced selections blending seamlessly on Material 3 components
                  color: selected
                      ? colorScheme.primary.transparency(0.08)
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? colorScheme.primary : colorScheme.outlineVariant.transparency(0.5),
                    width: selected ? 2 : 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          width: 2,
                        ),
                      ),
                      child: selected
                          ? Center(
                        child: SizedBox(
                          width: 10,
                          height: 10,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opt['title']!,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: selected ? colorScheme.primary : colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            opt['desc']!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: colorScheme.primary,
                        size: 22,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          YoField(
            label: _hospRequired
                ? 'Affiliated Hospital/Clinic Name *'
                : 'Affiliated Hospital/Clinic Name (Optional)',
            hint: 'e.g. City General Hospital',
            icon: Icons.apartment_rounded,
            controller: _hospCtrl,
            validator: _hospRequired
                ? (v) => (v == null || v.trim().isEmpty) ? 'Hospital name required' : null
                : null,
          ),
          const SizedBox(height: 28),
          NavButtons(
            onBack: widget.onBack,
            onNext: registerState.isLoading ? null : () async {
              if (_hospRequired && !_formKey.currentState!.validate()) return;

              widget.data.hospitalName = _hospCtrl.text.trim();

              final success = await ref
                  .read(doctorRegisterControllerProvider.notifier)
                  .saveStep4(widget.data);

              if (!context.mounted) return;

              if (success) {
                widget.onNext();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ref.read(doctorRegisterControllerProvider).errorMessage ?? "Step 4 Failed"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}