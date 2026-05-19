import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'shared_widgets.dart';

class Step4Practice extends StatefulWidget {
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
  State<Step4Practice> createState() => _Step4PracticeState();
}

class _Step4PracticeState extends State<Step4Practice> {
  final _hospCtrl = TextEditingController();

  final _options = const [
    {'title': 'Solo Practice', 'desc': 'Private clinic owned by you'},
    {'title': 'Multi-Speciality Clinic', 'desc': 'Shared practice with multiple doctors'},
    {'title': 'Hospital Attached', 'desc': 'Located within a hospital premises'},
    {'title': 'Visiting Consultant', 'desc': 'Consulting at various locations'},
    {'title': 'Government Hospital', 'desc': 'Practicing in a public health facility'},
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
    return StepCard(
      children: [
        StepTitle(
          icon: Icons.business_center_rounded,
          title: 'Practice Type',
          color: AppTheme.yoBlue,
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
                color: selected ? AppTheme.yoBlueLight : colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppTheme.yoBlue : colorScheme.outlineVariant,
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
                        color: selected ? AppTheme.yoBlue : colorScheme.onSurfaceVariant,
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
                                  color: AppTheme.yoBlue,
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
                            color: selected ? AppTheme.yoBlue : colorScheme.onSurface,
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
                      color: AppTheme.yoBlue,
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
          validator: _hospRequired ? (v) => v!.isEmpty ? 'Hospital name required' : null : null,
        ),
        const SizedBox(height: 28),
        NavButtons(
          onBack: widget.onBack,
          onNext: () {
            widget.data.hospitalName = _hospCtrl.text;
            widget.onNext();
          },
        ),
      ],
    );
  }
}
