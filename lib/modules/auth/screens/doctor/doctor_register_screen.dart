import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step1_personal.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step2_professional.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step3_clinic.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step4_practice.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step5_consultation.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step6_documents.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step7_declaration.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import '../../controllers/doctor_register_controller.dart';

class DoctorRegisterScreen extends ConsumerStatefulWidget {
  final int initialStep;

  const DoctorRegisterScreen({super.key, this.initialStep = 1});

  @override
  ConsumerState<DoctorRegisterScreen> createState() =>
      _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends ConsumerState<DoctorRegisterScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  final DoctorFormData _formData = DoctorFormData();
  late final PageController _pageController;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<String> _stepLabels = const [
    'Personal',
    'Professional',
    'Clinic',
    'Practice',
    'Consultation',
    'Documents',
    'Submit',
  ];

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep - 1;
    _pageController = PageController(initialPage: _currentStep);

    if (widget.initialStep > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Welcome back! Continue your registration from Step ${widget.initialStep}.",
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep >= _stepLabels.length - 1) return;
    final nextPage = _currentStep + 1;
    setState(() => _currentStep = nextPage);
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _prevStep() {
    if (_currentStep <= 0) return;
    final prevPage = _currentStep - 1;
    setState(() => _currentStep = prevPage);
    _pageController.animateToPage(
      prevPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleSubmit() async {
    final notifier = ref.read(doctorRegisterControllerProvider.notifier);

    final success = await notifier.submitRegistration(_formData);

    if (!mounted) return;

    if (!success) {
      final errorMessage =
          ref.read(doctorRegisterControllerProvider).errorMessage ??
          "Registration Failed";
      _showErrorSnackBar(errorMessage);
      return;
    }

    await notifier.logoutRegistration();

    if (!mounted) return;

    _formData.reset();

    context.go(AppRoutes.waitingApproval);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Watch registration state context for overlay loading hooks if required
    final registerState = ref.watch(doctorRegisterControllerProvider);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            Column(
              children: [
                Hero(
                  tag: 'docAppBar',
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.doctorGradient,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_currentStep == 0) {
                                      context.pop();
                                    } else {
                                      _prevStep();
                                    }
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
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Yo',
                                        style: textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: colorScheme.onPrimary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Doctor',
                                        style: textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: colorScheme.onPrimary.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 40,
                                  child: Center(
                                    child: Text(
                                      '${_currentStep + 1}/${_stepLabels.length}',
                                      style: textTheme.labelMedium?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _stepLabels[_currentStep],
                              key: ValueKey(_currentStep),
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildStepperDots(context),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _scrollable(
                        Step1Personal(
                          data: _formData,
                          onNext: () async {
                            final success = await ref
                                .read(doctorRegisterControllerProvider.notifier)
                                .registerStep1(_formData);
                            if (!context.mounted) return;
                            if (success) {
                              _nextStep();
                            } else {
                              _showErrorSnackBar(
                                ref
                                        .read(doctorRegisterControllerProvider)
                                        .errorMessage ??
                                    "Step 1 Failed",
                              );
                            }
                          },
                        ),
                      ),
                      _scrollable(
                        Step2Professional(
                          data: _formData,
                          onBack: _prevStep,
                          onNext: () async {
                            final success = await ref
                                .read(doctorRegisterControllerProvider.notifier)
                                .registerStep2(_formData);
                            if (!context.mounted) return;
                            if (success) {
                              _nextStep();
                            } else {
                              _showErrorSnackBar(
                                ref
                                        .read(doctorRegisterControllerProvider)
                                        .errorMessage ??
                                    "Step 2 Failed",
                              );
                            }
                          },
                        ),
                      ),
                      _scrollable(
                        Step3Clinic(
                          data: _formData,
                          onBack: _prevStep,
                          onNext: () async {
                            final success = await ref
                                .read(doctorRegisterControllerProvider.notifier)
                                .registerStep3(_formData);
                            if (!context.mounted) return;
                            if (success) {
                              _nextStep();
                            } else {
                              _showErrorSnackBar(
                                ref
                                        .read(doctorRegisterControllerProvider)
                                        .errorMessage ??
                                    "Step 3 Failed",
                              );
                            }
                          },
                        ),
                      ),
                      _scrollable(
                        Step4Practice(
                          data: _formData,
                          onBack: _prevStep,
                          onNext: () async {
                            final success = await ref
                                .read(doctorRegisterControllerProvider.notifier)
                                .saveStep4(_formData);
                            if (!context.mounted) return;
                            if (success) {
                              _nextStep();
                            } else {
                              _showErrorSnackBar(
                                ref
                                        .read(doctorRegisterControllerProvider)
                                        .errorMessage ??
                                    "Step 4 Failed",
                              );
                            }
                          },
                        ),
                      ),
                      _scrollable(
                        Step5Consultation(
                          data: _formData,
                          onBack: _prevStep,
                          onNext: () async {
                            final success = await ref
                                .read(doctorRegisterControllerProvider.notifier)
                                .saveStep5(_formData);
                            if (!context.mounted) return;
                            if (success) {
                              _nextStep();
                            } else {
                              _showErrorSnackBar(
                                ref
                                        .read(doctorRegisterControllerProvider)
                                        .errorMessage ??
                                    "Step 5 Failed",
                              );
                            }
                          },
                        ),
                      ),
                      _scrollable(
                        Step6Documents(
                          data: _formData,
                          onBack: _prevStep,
                          onNext: () async {
                            final success = await ref
                                .read(doctorRegisterControllerProvider.notifier)
                                .saveStep6(_formData);
                            if (!context.mounted) return;
                            if (success) {
                              _nextStep();
                            } else {
                              _showErrorSnackBar(
                                ref
                                        .read(doctorRegisterControllerProvider)
                                        .errorMessage ??
                                    "Step 6 Failed",
                              );
                            }
                          },
                        ),
                      ),
                      _scrollable(
                        Step7Declaration(
                          data: _formData,
                          onBack: _prevStep,
                          onSubmit: _handleSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (registerState.isLoading)
              Container(
                color: Colors.black.transparency(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _scrollable(Widget child) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    child: child,
  );

  Widget _buildStepperDots(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_stepLabels.length, (i) {
          final done = i < _currentStep;
          final active = i == _currentStep;
          return Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: active ? 26 : 20,
                  height: active ? 26 : 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done || active
                        ? colorScheme.onPrimary
                        : colorScheme.onPrimary.transparency(0.3),
                  ),
                  child: Center(
                    child: done
                        ? Icon(
                            Icons.check,
                            size: 12,
                            color: colorScheme.primary,
                          )
                        : Text(
                            '${i + 1}',
                            style: textTheme.labelSmall?.copyWith(
                              color: active
                                  ? colorScheme.primary
                                  : colorScheme.onPrimary.transparency(0.7),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
                if (i < _stepLabels.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: i < _currentStep
                          ? colorScheme.onPrimary
                          : colorScheme.onPrimary.transparency(0.3),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
