import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/info_box.dart';
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

    if (!_formKey.currentState!.validate()) {
      AppSnackBar.show(
        message: 'Please resolve the highlighted errors',
        type: AppSnackBarType.warning,
      );
      return;
    }

    _save();

    final success = await ref
        .read(doctorRegisterControllerProvider.notifier)
        .registerStep2(widget.data);

    if (!mounted) return;

    if (success) {
      AppSnackBar.show(
        message: 'Professional details saved successfully!',
        type: AppSnackBarType.success,
      );
      widget.onNext();
    } else {
      final errorMsg = ref.read(doctorRegisterControllerProvider).errorMessage;
      AppSnackBar.show(
        message: errorMsg ?? "Step 2 registration failed. Try again.",
        type: AppSnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
            subtitle:
                'Enter your medical qualifications and council credentials',
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Primary Qualification Dropdown
          AppDropdownField<String>(
            label: 'Primary Qualification',
            isRequired: true,
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

          // Specialization Field
          AppTextField(
            label: 'Specialization',
            isRequired: true,
            hint: 'Enter your primary specialization',
            icon: Icons.local_hospital_outlined,
            controller: _specCtrl,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Specialization required'
                : null,
          ),
          const SizedBox(height: 16),

          // Years of Experience Field
          AppTextField(
            label: 'Years of Experience',
            isRequired: true,
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

          // Medical Council Registration Number Field
          AppTextField(
            label: 'Medical Council Reg. Number',
            isRequired: true,
            hint: 'e.g., MMC/2018/12345 or MCI-12345',
            icon: Icons.badge_outlined,
            controller: _regCtrl,
            maxLength: 25,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              TextInputFormatter.withFunction(
                (oldValue, newValue) => TextEditingValue(
                  text: newValue.text.toUpperCase(),
                  selection: newValue.selection,
                ),
              ),
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

          // Registering State Council Field
          AppTextField(
            label: 'Registering State Council',
            isRequired: true,
            hint: 'Enter state medical council name',
            icon: Icons.account_balance_outlined,
            controller: _councilCtrl,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'State council required'
                : null,
          ),
          const SizedBox(height: 16),

          AppDatePickerField(
            label: 'Registration Valid Till',
            isRequired: true,
            hint: 'Select expiry date',
            icon: Icons.calendar_today_rounded,
            value: widget.data.validTill,
            firstDate: DateTime.now(),
            lastDate: DateTime(2045),
            onChanged: (date) {
              setState(() => widget.data.validTill = date);
            },
            validator: (date) {
              if (date == null) {
                return 'Registration validity date required';
              }
              return null;
            },
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
