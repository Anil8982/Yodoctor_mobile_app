import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/modules/auth/models/doctor_register_model.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step1_personal.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step2_professional.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step3_clinic.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step4_practice.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step5_consultation.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step6_documents.dart';
import 'package:yodoctor/modules/auth/screens/doctor/register_steps/step7_declaration.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen>
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
    _pageController = PageController(initialPage: 0);
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
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registration submitted successfully!'),
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            Container(
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
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _currentStep == 0 ? Navigator.pop(context) : _prevStep(),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary.transparency(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: colorScheme.onPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                          const Spacer(),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'yo',
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Doctor',
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onPrimary.transparency(0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimary.transparency(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_currentStep + 1}/${_stepLabels.length}',
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
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
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _scrollable(Step1Personal(data: _formData, onNext: _nextStep)),
                  _scrollable(
                    Step2Professional(data: _formData, onNext: _nextStep, onBack: _prevStep),
                  ),
                  _scrollable(
                    Step3Clinic(data: _formData, onNext: _nextStep, onBack: _prevStep),
                  ),
                  _scrollable(
                    Step4Practice(data: _formData, onNext: _nextStep, onBack: _prevStep),
                  ),
                  _scrollable(
                    Step5Consultation(data: _formData, onNext: _nextStep, onBack: _prevStep),
                  ),
                  _scrollable(
                    Step6Documents(data: _formData, onNext: _nextStep, onBack: _prevStep),
                  ),
                  _scrollable(
                    Step7Declaration(data: _formData, onBack: _prevStep, onSubmit: _handleSubmit),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scrollable(Widget child) => SingleChildScrollView(
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
                        ? Icon(Icons.check, size: 12, color: colorScheme.primary)
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
