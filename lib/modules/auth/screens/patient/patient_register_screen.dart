import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/controllers/patient_register_controller.dart';
import 'package:yodoctor/modules/auth/widgets/auth_widgets.dart';
import 'package:yodoctor/modules/widgets/app_date_picker_field.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class PatientRegisterScreen extends ConsumerStatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  ConsumerState<PatientRegisterScreen> createState() =>
      _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends ConsumerState<PatientRegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  static const String _subTag = 'PatientRegisterScreen';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  bool _submittedOnce = false;

  @override
  void initState() {
    super.initState();
    AppLogger.info(
      'PatientRegisterScreen Initialized',
      tag: LogTags.ui,
      subTag: _subTag,
    );
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    AppLogger.info(
      'PatientRegisterScreen Disposed',
      tag: LogTags.ui,
      subTag: _subTag,
    );
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() {
      _submittedOnce = true;
    });
    if (!_formKey.currentState!.validate()) {
      AppLogger.warning(
        'Form validation failed for patient registration',
        tag: LogTags.ui,
        subTag: _subTag,
      );
      return;
    }

    AppLogger.info(
      'Form validation passed. Triggering patient registration flow...',
      tag: LogTags.ui,
      subTag: _subTag,
    );

    ref
        .read(patientRegisterControllerProvider.notifier)
        .registerPatient(
          context: context,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final registerState = ref.watch(patientRegisterControllerProvider);
    final controllerNotifier = ref.read(
      patientRegisterControllerProvider.notifier,
    );

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.secondary,
                    AppTheme.secondary.transparency(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              AppLogger.info(
                                'Back arrow tapped, popping register screen',
                                tag: LogTags.ui,
                                subTag: _subTag,
                              );
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary.transparency(0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Patient Registration',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.transparency(0.07),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _submittedOnce
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.yoGreenLight,
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                color: AppTheme.yoGreen,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Account',
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'Join yoDoctor as a Patient',
                                  style: textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        _sectionLabel(context, 'Personal Information'),
                        const SizedBox(height: 14),
                        AppTextField(
                          label: 'Full Name',
                          isRequired: true,
                          hint: 'Enter your full name',
                          icon: Icons.person_rounded,
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Enter name';
                            }
                            if (v.trim().length < 3) {
                              return 'Enter a valid name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Email Address',
                          isRequired: true,
                          hint: 'patient@example.com',
                          icon: Icons.email_rounded,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email required';
                            }
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
                        AppTextField(
                          label: 'Phone Number',
                          isRequired: true,
                          hint: '9876543210',
                          icon: Icons.phone_rounded,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Enter phone number';
                            }
                            final indianPhoneRegExp = RegExp(r'^[6-9]\d{9}$');
                            if (!indianPhoneRegExp.hasMatch(v.trim())) {
                              return 'Enter a valid 10-digit mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppDatePickerField(
                          label: 'Date of Birth',
                          isRequired: true,
                          hint: 'Select date of birth',
                          icon: Icons.cake_rounded,
                          value: registerState.selectedDOB,
                          firstDate: DateTime(1920),
                          lastDate: DateTime.now(),
                          onChanged: (date) {
                            controllerNotifier.selectDateOfBirth(date);
                          },
                          validator: (date) {
                            if (date == null) {
                              return 'Select date of birth';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppDropdownField(
                          label: 'Gender',
                          isRequired: true,
                          hint: 'Select gender',
                          icon: Icons.wc_rounded,
                          value: registerState.selectedGender,
                          items: const ['Male', 'Female', 'Other'],
                          onChanged: (value) {
                            controllerNotifier.selectGender(value!);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Select gender';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        _sectionLabel(context, 'Account Security'),
                        const SizedBox(height: 14),
                        AppTextField(
                          label: 'Password',
                          isRequired: true,
                          hint: 'Create password',
                          icon: Icons.lock_rounded,
                          controller: _passwordController,
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
                        AppTextField(
                          label: 'Confirm Password',
                          isRequired: true,
                          hint: 'Re-enter password',
                          icon: Icons.lock_rounded,
                          controller: _confirmPasswordController,
                          isPassword: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Confirm password required';
                            }
                            if (v != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            final targetValue = !registerState.agreedToTerms;
                            AppLogger.info(
                              'Toggling terms checkbox selection path to: $targetValue',
                              tag: LogTags.ui,
                              subTag: _subTag,
                            );
                            controllerNotifier.toggleTerms(targetValue);
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: registerState.agreedToTerms
                                      ? AppTheme.secondary
                                      : colorScheme.surface.transparency(0),
                                  border: Border.all(
                                    color: registerState.agreedToTerms
                                        ? AppTheme.secondary
                                        : colorScheme.outlineVariant,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: registerState.agreedToTerms
                                    ? Icon(
                                        Icons.check,
                                        color: colorScheme.onPrimary,
                                        size: 14,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: textTheme.labelMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: textTheme.labelMedium?.copyWith(
                                          color: AppTheme.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: textTheme.labelMedium?.copyWith(
                                          color: AppTheme.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        YoPrimaryButton(
                          label: 'Register as Patient',
                          onTap: _submitForm,
                          color: AppTheme.secondary,
                          isLoading: registerState.isLoading,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  AppLogger.info(
                                    'Redirecting to login via navigation pop block',
                                    tag: LogTags.ui,
                                    subTag: _subTag,
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Login here',
                                  style: textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.secondary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppTheme.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.secondary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
