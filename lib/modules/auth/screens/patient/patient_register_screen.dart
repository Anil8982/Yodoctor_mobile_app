import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/auth/controllers/patient_register_controller.dart';
import 'package:yodoctor/modules/auth/widgets/auth_widgets.dart';

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
      appBar: AppBar(
        elevation: 10,
        title: Text(
          'Patient Registration',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        leadingWidth: 56,

      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
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
                        YoTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          prefixIcon: Icons.person_rounded,
                          validator: (v) => v!.isEmpty ? 'Enter name' : null,
                        ),
                        const SizedBox(height: 16),
                        YoTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'patient@example.com',
                          prefixIcon: Icons.email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter email';
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        YoTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: '+91 9876543210',
                          prefixIcon: Icons.phone_rounded,
                          keyboardType: TextInputType.phone,
                          validator: (v) => v!.isEmpty ? 'Enter phone' : null,
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date of Birth',
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                AppLogger.info(
                                  'Triggering Date of Birth picker bottom sheet/dialog',
                                  tag: LogTags.ui,
                                  subTag: _subTag,
                                );
                                controllerNotifier.pickDateOfBirth(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant,
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      color: AppTheme.secondary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      registerState.selectedDOB != null
                                          ? DateFormat(
                                              'dd/MM/yyyy',
                                            ).format(registerState.selectedDOB!)
                                          : 'Select date of birth',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: registerState.selectedDOB != null
                                            ? colorScheme.onSurface
                                            : colorScheme.onSurfaceVariant
                                                  .transparency(0.65),
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (registerState.dobError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  registerState.dobError!,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.error,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender',
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _genderButton(
                                  context,
                                  'Male',
                                  registerState.selectedGender,
                                ),
                                _genderButton(
                                  context,
                                  'Female',
                                  registerState.selectedGender,
                                ),
                                _genderButton(
                                  context,
                                  'Other',
                                  registerState.selectedGender,
                                ),
                              ],
                            ),
                            if (registerState.genderError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  registerState.genderError!,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.error,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _sectionLabel(context, 'Account Security'),
                        const SizedBox(height: 14),
                        YoTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Min. 8 characters',
                          prefixIcon: Icons.lock_rounded,
                          isPassword: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter password';
                            if (v.length < 8) {
                              return 'Password must be 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        YoTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hint: 'Re-enter password',
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Confirm password';
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

  Widget _genderButton(
    BuildContext context,
    String gender,
    String? currentSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selected = currentSelected == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          AppLogger.info(
            'Gender selected row state update ->: $gender',
            tag: LogTags.ui,
            subTag: _subTag,
          );
          ref
              .read(patientRegisterControllerProvider.notifier)
              .selectGender(gender);
        },
        child: Container(
          margin: EdgeInsets.only(right: gender != 'Other' ? 10 : 0),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.secondary
                : colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.secondary : colorScheme.outlineVariant,
              width: 1.5,
            ),
          ),
          child: Text(
            gender,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: selected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
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
