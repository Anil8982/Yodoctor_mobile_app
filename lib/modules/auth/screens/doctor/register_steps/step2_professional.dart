import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/app_text_field.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/info_box.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/section_label.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_card.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_title.dart';

import '../widgets/nav_buttons.dart';

class Step2Professional extends ConsumerStatefulWidget {
  final DoctorFormData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step2Professional({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<Step2Professional> createState() => _Step2ProfessionalState();
}

class _Step2ProfessionalState extends ConsumerState<Step2Professional> {
  final _formKey = GlobalKey<FormState>();
  final _specCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _regCtrl = TextEditingController();
  final _councilCtrl = TextEditingController();
  String? _qualification;
  bool _submittedOnce = false;

  @override
  void initState() {
    super.initState();
    _specCtrl.text = widget.data.specialization;
    _expCtrl.text = widget.data.experience;
    _regCtrl.text = widget.data.regNumber;
    _councilCtrl.text = widget.data.stateCouncil;
    _qualification = widget.data.qualification.isEmpty
        ? null
        : widget.data.qualification;
  }

  @override
  void dispose() {
    _specCtrl.dispose();
    _expCtrl.dispose();
    _regCtrl.dispose();
    _councilCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.data.qualification = _qualification ?? '';
    widget.data.specialization = _specCtrl.text.trim();
    widget.data.experience = _expCtrl.text.trim();
    widget.data.regNumber = _regCtrl.text.trim();
    widget.data.stateCouncil = _councilCtrl.text.trim();
  }

  Future<void> _handleNext() async {
    setState(() => _submittedOnce = true);

    if (!_formKey.currentState!.validate()) return;

    if (widget.data.validTill == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select registration validity date'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    _save();

    final success = await ref
        .read(doctorRegisterControllerProvider.notifier)
        .registerStep2(widget.data);

    if (!mounted) return;

    if (success) {
      widget.onNext();
    } else {
      final errorMsg = ref.read(doctorRegisterControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? "Step 2 registration failed. Try again."),
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
            icon: Icons.school_rounded,
            title: 'Professional Details',
            subtitle: 'Enter your medical qualifications and council credentials',
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Primary Qualification
          AppDropdownField(
            label: 'Primary Qualification *',
            hint: 'Select primary qualification',
            icon: Icons.menu_book_outlined,
            value: _qualification,
            items: const [
              'MBBS',
              'MD',
              'MS',
              'BDS',
              'MDS',
              'BAMS',
              'BHMS',
              'Other',
            ],
            onChanged: (v) => setState(() => _qualification = v),
            validator: (v) => v == null ? 'Select qualification' : null,
          ),
          const SizedBox(height: 16),

          // Specialization
          AppTextField(
            label: 'Specialization *',
            hint: 'Enter your primary specialization',
            icon: Icons.local_hospital_outlined,
            controller: _specCtrl,
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Specialization required' : null,
          ),
          const SizedBox(height: 16),

          // Years of Experience
          AppTextField(
            label: 'Years of Experience *',
            hint: 'Enter total years of practice',
            icon: Icons.workspace_premium_outlined,
            controller: _expCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Experience required';
              final exp = int.tryParse(v);
              if (exp == null || exp > 60) return 'Enter valid experience';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Medical Council Reg Number
          AppTextField(
            label: 'Medical Council Reg. Number',
            isRequired: true,
            hint: 'e.g., MMC/2018/12345 or MCI-12345',
            icon: Icons.badge_outlined,
            controller: _regCtrl,
            maxLength: 25, // Maximum limit
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              UpperCaseTextFormatter(),
              // (A-Z, 0-9, /, - allowed)
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9/-]')),
            ],
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Registration number required';
              }

              final cleaned = v.trim();
              if (cleaned.length < 4) {
                return 'Registration number too short';
              }
              if (cleaned.length > 25) {
                return 'Registration number cannot exceed 25 characters';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          // Registering State Council
          AppTextField(
            label: 'Registering State Council *',
            hint: 'Enter state medical council name',
            icon: Icons.account_balance_outlined,
            controller: _councilCtrl,
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'State council required' : null,
          ),
          const SizedBox(height: 24),

          // Registration Validity Date
          const SectionLabel(label: 'Registration Valid Till', isRequired: true),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: widget.data.validTill ??
                    DateTime.now().add(const Duration(days: 365)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2045),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: Theme.of(ctx).colorScheme.copyWith(
                      primary: colorScheme.primary,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                setState(() => widget.data.validTill = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: (_submittedOnce && widget.data.validTill == null)
                      ? colorScheme.error
                      : colorScheme.outlineVariant.transparency(0.5),
                  width: (_submittedOnce && widget.data.validTill == null) ? 1.4 : 1.2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.data.validTill != null
                          ? '${widget.data.validTill!.day.toString().padLeft(2, '0')}/${widget.data.validTill!.month.toString().padLeft(2, '0')}/${widget.data.validTill!.year}'
                          : 'Select expiry date',
                      style: textTheme.bodyMedium?.copyWith(
                        color: widget.data.validTill != null
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant.transparency(0.7),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Date must be in the future',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Compliance Note
          const InfoBox(
            text:
            'Your registration details will be verified with the official state medical council for authenticity.',
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


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}