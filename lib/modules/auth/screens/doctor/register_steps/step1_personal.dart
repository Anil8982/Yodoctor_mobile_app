import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/modules/auth/controllers/doctor_register_controller.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_multi_select_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_card.dart';
import 'package:yodoctor/modules/auth/screens/doctor/widgets/step_title.dart';

import '../widgets/next_button.dart';

class Step1Personal extends ConsumerStatefulWidget {
  final DoctorFormData data;
  final VoidCallback onNext;

  const Step1Personal({
    super.key,
    required this.data,
    required this.onNext,
  });

  @override
  ConsumerState<Step1Personal> createState() => _Step1PersonalState();
}

class _Step1PersonalState extends ConsumerState<Step1Personal> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _passCtrl;
  late final TextEditingController _confirmCtrl;

  String? _gender;
  bool _submittedOnce = false;

  static const List<String> _langs = [
    'English',
    'Hindi',
    'Marathi',
    'Telugu',
    'Tamil',
    'Bengali',
    'Gujarati',
    'Kannada',
    'Malayalam',
    'Punjabi',
    'Odia',
    'Assamese',
    'Urdu',
    'Bhojpuri',
    'Maithili',
    'Santhali',
    'Kashmiri',
    'Nepali',
    'Konkani',
    'Dogri',
    'Manipuri',
    'Sanskrit',
    'Other',
  ];

  int get _wordCount {
    final text = _bioCtrl.text.trim();
    return text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
  }

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.data.fullName);
    _emailCtrl = TextEditingController(text: widget.data.email);
    _mobileCtrl = TextEditingController(text: widget.data.mobile);
    _bioCtrl = TextEditingController(text: widget.data.bio);
    _passCtrl = TextEditingController(text: widget.data.password);
    _confirmCtrl = TextEditingController(text: widget.data.confirmPassword);

    _gender = widget.data.gender.isEmpty ? null : widget.data.gender;
    _bioCtrl.addListener(_onBioChanged);
  }

  void _onBioChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bioCtrl.removeListener(_onBioChanged);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _bioCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.data.fullName = _nameCtrl.text.trim();
    widget.data.email = _emailCtrl.text.trim();
    widget.data.mobile = _mobileCtrl.text.trim();
    widget.data.gender = _gender ?? '';
    widget.data.bio = _bioCtrl.text.trim();
    widget.data.password = _passCtrl.text;
    widget.data.confirmPassword = _confirmCtrl.text;
  }

  Future<void> _handleNext() async {
    setState(() => _submittedOnce = true);

    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) return;

    _save();

    final success = await ref
        .read(doctorRegisterControllerProvider.notifier)
        .registerStep1(widget.data);

    if (!mounted) return;

    if (success) {
      widget.onNext();
    } else {
      final errorMsg = ref.read(doctorRegisterControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? "Registration failed. Please try again."),
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
            icon: Icons.person_outline_rounded,
            title: 'Personal Information',
            subtitle: 'Enter your account details and profile information',
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // Full Name
          AppTextField(
            label: 'Full Name',
            isRequired: true,
            hint: 'Enter your full name',
            icon: Icons.person_outline_rounded,
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Full name required';
              if (v.trim().length < 3) return 'Enter a valid name';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email Address
          AppTextField(
            label: 'Email Address',
            isRequired: true,
            hint: 'Enter your email address',
            icon: Icons.alternate_email_rounded,
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email required';
              final emailRegExp = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              );
              if (!emailRegExp.hasMatch(v.trim())) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Mobile Number
          AppTextField(
            label: 'Mobile Number',
            isRequired: true,
            hint: 'Enter 10-digit mobile number',
            icon: Icons.phone_android_rounded,
            controller: _mobileCtrl,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Mobile required';
              final indianPhoneRegExp = RegExp(r'^[6-9]\d{9}$');
              if (!indianPhoneRegExp.hasMatch(v.trim())) {
                return 'Enter a valid 10-digit mobile number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Gender Selection
          AppDropdownField(
            label: 'Gender',
            isRequired: true,
            hint: 'Select gender',
            icon: Icons.wc_rounded,
            value: _gender,
            items: const ['Male', 'Female', 'Other'],
            onChanged: (v) => setState(() => _gender = v),
            validator: (v) => v == null ? 'Select gender' : null,
          ),
          const SizedBox(height: 16),

          // Password
          AppTextField(
            label: 'Password',
            isRequired: true,
            hint: 'Create password',
            icon: Icons.lock_outline_rounded,
            controller: _passCtrl,
            isPassword: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password required';
              if (v.length < 8) return 'Minimum 8 characters required';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password
          AppTextField(
            label: 'Confirm Password',
            isRequired: true,
            hint: 'Re-enter password',
            icon: Icons.lock_reset_rounded,
            controller: _confirmCtrl,
            isPassword: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Confirm password required';
              if (v != _passCtrl.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Languages Spoken
          AppMultiSelectField(
            label: 'Languages Spoken',
            isRequired: true,
            hint: 'Select spoken languages',
            icon: Icons.translate_rounded,
            selectedItems: widget.data.languages,
            options: _langs,
            validator: (list) {
              if (list == null || list.isEmpty) {
                return 'Select at least one language';
              }
              return null;
            },
            onChanged: (updatedList) {
              setState(() {});
            },
          ),
          const SizedBox(height: 16),

          // Professional Bio
          AppTextField(
            label: 'Professional Bio',
            isRequired: true,
            hint: 'Write a brief summary about your expertise and background...',
            icon: Icons.notes_rounded,
            controller: _bioCtrl,
            maxLines: 4,
            validator: (_) {
              if (_wordCount < 30) return 'Minimum 30 words required';
              if (_wordCount > 100) return 'Maximum 100 words allowed';
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
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
                  '$_wordCount/100 words',
                  style: textTheme.labelSmall?.copyWith(
                    color: (_wordCount < 30 || _wordCount > 100)
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                    fontWeight: (_wordCount < 30 || _wordCount > 100)
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Next Action Button
          NextButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            color: colorScheme.primary,
            isLoading: registerState.isLoading,
            onTap: registerState.isLoading ? null : _handleNext,
          ),
        ],
      ),
    );
  }
}