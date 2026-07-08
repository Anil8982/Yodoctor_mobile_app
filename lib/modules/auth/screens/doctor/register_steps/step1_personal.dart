import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'shared_widgets.dart';
import 'package:provider/provider.dart';
import '../../../controllers/doctor_register_controller.dart';

class Step1Personal extends StatefulWidget {
  final DoctorFormData data;
  final VoidCallback onNext;

  const Step1Personal({super.key, required this.data, required this.onNext});

  @override
  State<Step1Personal> createState() => _Step1PersonalState();
}

class _Step1PersonalState extends State<Step1Personal> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String? _gender;

  final _langs = const [
    'English',
    'Hindi',
    'Telugu',
    'Marathi',
    'Tamil',
    'Bengali',
    'Gujarati',
    'Kannada',
    'Other',
  ];

  int get _wordCount => _bioCtrl.text.trim().isEmpty
      ? 0
      : _bioCtrl.text.trim().split(RegExp(r'\s+')).length;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.data.fullName;
    _emailCtrl.text = widget.data.email;
    _mobileCtrl.text = widget.data.mobile;
    _bioCtrl.text = widget.data.bio;
    _passCtrl.text = widget.data.password;
    _confirmCtrl.text = widget.data.confirmPassword;
    _gender = widget.data.gender.isEmpty ? null : widget.data.gender;
    _bioCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _bioCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.data.fullName = _nameCtrl.text;
    widget.data.email = _emailCtrl.text;
    widget.data.mobile = _mobileCtrl.text;
    widget.data.gender = _gender ?? '';
    widget.data.bio = _bioCtrl.text;
    widget.data.password = _passCtrl.text;
    widget.data.confirmPassword = _confirmCtrl.text;
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
            icon: Icons.person_rounded,
            title: 'Personal Information',
            color: AppTheme.yoBlue,
          ),
          const SizedBox(height: 24),
          YoField(
            label: 'Full Name *',
            hint: 'Dr. John Doe',
            icon: Icons.person_rounded,
            controller: _nameCtrl,
            validator: (v) => v!.isEmpty ? 'Full name required' : null,
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Email Address *',
            hint: 'doctor@hospital.com',
            icon: Icons.email_rounded,
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Email required';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) {
                return 'Enter valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Mobile Number *',
            hint: '9876543210',
            icon: Icons.phone_rounded,
            controller: _mobileCtrl,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Mobile required';
              }
              if (v.length != 10) {
                return 'Enter valid 10-digit number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownField(
            label: 'Gender *',
            icon: Icons.wc_rounded,
            value: _gender,
            items: const ['Male', 'Female', 'Other'],
            onChanged: (v) => setState(() => _gender = v),
            validator: (v) => v == null ? 'Select gender' : null,
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Password *',
            hint: 'Min. 8 characters',
            icon: Icons.lock_rounded,
            controller: _passCtrl,
            isPassword: true,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Password required';
              }
              if (v.length < 8) {
                return 'Minimum 8 characters required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          YoField(
            label: 'Confirm Password *',
            hint: 'Re-enter password',
            icon: Icons.lock_outline_rounded,
            controller: _confirmCtrl,
            isPassword: true,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Confirm password';
              }
              if (v != _passCtrl.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const SectionLabel(label: 'Languages Spoken *'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _langs.map((lang) {
              final selected = widget.data.languages.contains(lang);
              return GestureDetector(
                onTap: () => setState(
                  () => selected
                      ? widget.data.languages.remove(lang)
                      : widget.data.languages.add(lang),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
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
                    lang,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
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
          const SectionLabel(label: 'Professional Bio *'),
          const SizedBox(height: 10),
          TextFormField(
            controller: _bioCtrl,
            maxLines: 4,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            decoration: inputDeco(
              context,
              'Share a brief overview of your expertise...',
              Icons.description_rounded,
            ),
            validator: (v) =>
                _wordCount < 30 ? 'Minimum 30 words required' : null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minimum 30 words required',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '$_wordCount/100',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          NextButton(
            label: 'Next →',
            color: AppTheme.yoBlue,
            onTap: () async {
              if (!_formKey.currentState!.validate()) return;

              _save();

              final controller = context.read<DoctorRegisterController>();

              final success = await controller.registerStep1(widget.data);

              if (!mounted) return;

              if (success) {
                widget.onNext();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(controller.error ?? "Registration Failed"),
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
