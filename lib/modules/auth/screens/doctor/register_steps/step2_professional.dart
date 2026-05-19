import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'shared_widgets.dart';

class Step2Professional extends StatefulWidget {
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
  State<Step2Professional> createState() => _Step2ProfessionalState();
}

class _Step2ProfessionalState extends State<Step2Professional> {
  final _formKey = GlobalKey<FormState>();
  final _specCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _regCtrl = TextEditingController();
  final _councilCtrl = TextEditingController();
  String? _qualification;

  @override
  void initState() {
    super.initState();
    _specCtrl.text = widget.data.specialization;
    _expCtrl.text = widget.data.experience;
    _regCtrl.text = widget.data.regNumber;
    _councilCtrl.text = widget.data.stateCouncil;
    _qualification = widget.data.qualification.isEmpty ? null : widget.data.qualification;
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
    widget.data.specialization = _specCtrl.text;
    widget.data.experience = _expCtrl.text;
    widget.data.regNumber = _regCtrl.text;
    widget.data.stateCouncil = _councilCtrl.text;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: StepCard(
        children: [
          StepTitle(
            icon: Icons.school_rounded,
            title: 'Professional Details',
            color: AppTheme.yoBlue,
          ),
          const SizedBox(height: 24),
          DropdownField(
            label: 'Primary Qualification',
            icon: Icons.menu_book_rounded,
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
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Specialization *',
            hint: 'e.g. Cardiology',
            icon: Icons.local_hospital_rounded,
            controller: _specCtrl,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Years of Experience',
            hint: 'e.g. 8',
            icon: Icons.workspace_premium_rounded,
            controller: _expCtrl,
            validator: (v) {
              if (v == null || v.isEmpty) return null;
              if (int.parse(v) > 60) return 'Invalid experience';
              return null;
            },
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Medical Council Reg. Number *',
            hint: 'Reg-12345678',
            icon: Icons.badge_rounded,
            controller: _regCtrl,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Registering State Council *',
            hint: 'e.g. Maharashtra Medical Council',
            icon: Icons.account_balance_rounded,
            controller: _councilCtrl,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          const SectionLabel(label: 'Registration Valid Till'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate:
                    widget.data.validTill ?? DateTime.now().add(const Duration(days: 365)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2040),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: AppTheme.yoBlue),
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
                border: Border.all(color: colorScheme.outlineVariant, width: 1.2),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded, color: AppTheme.yoBlue, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    widget.data.validTill != null
                        ? '${widget.data.validTill!.day}/${widget.data.validTill!.month}/${widget.data.validTill!.year}'
                        : 'Select date (must be future date)',
                    style: textTheme.bodyMedium?.copyWith(
                      color: widget.data.validTill != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Must be a future date',
              style: textTheme.bodySmall?.copyWith(color: AppTheme.yoBlue),
            ),
          ),
          const SizedBox(height: 20),
          const InfoBox(
            text:
                'By submitting these details, we may verify your credentials with the relevant medical councils to maintain platform integrity.',
          ),
          const SizedBox(height: 28),
          NavButtons(
            onBack: widget.onBack,
            onNext: () {
              if (_formKey.currentState!.validate()) {
                _save();
                widget.onNext();
              }
            },
          ),
        ],
      ),
    );
  }
}
