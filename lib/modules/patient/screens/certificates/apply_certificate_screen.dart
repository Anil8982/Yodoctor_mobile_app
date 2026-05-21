import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/responsive.dart';
import '../../controllers/certificate_request.dart';
import 'widgets/step_progress_indicator.dart';
import 'widgets/step_1_type_selection.dart';
import 'widgets/step_2_medical_info.dart';
import 'widgets/step_3_document_upload.dart';
import 'widgets/step_4_review_submit.dart';

class ApplyCertificateScreen extends StatefulWidget {
  const ApplyCertificateScreen({super.key});

  @override
  State<ApplyCertificateScreen> createState() => _ApplyCertificateScreenState();
}

class _ApplyCertificateScreenState extends State<ApplyCertificateScreen> {
  int _currentStep = 1;
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  bool _confirmDisclaimer = false;

  final List<String> _steps = ['Type', 'Medical Info', 'Documents', 'Review'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final horizontalPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Apply for Certificate', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Consumer<CertificateController>(
        builder: (context, controller, child) {
          final subtitleText = controller.assignedDoctor != null
              ? 'Requesting from ${controller.assignedDoctor!.name} — ${controller.assignedDoctor!.specialty}'
              : 'Choose certificate type and details';

          return Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4), width: 1),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        subtitleText,
                        key: ValueKey(subtitleText),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    StepProgressIndicator(
                      currentStep: _currentStep,
                      steps: _steps,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 100),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _buildCurrentStepView(controller),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<CertificateController>(
        builder: (context, controller, child) {
          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
              ),
            ),
            padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, MediaQuery.paddingOf(context).bottom + 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleBackNavigation(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(_currentStep == 1 ? 'Cancel' : 'Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: controller.isLoading ? null : () => _handleNextStep(controller),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: controller.isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                        : Text(_currentStep == 4 ? 'Submit Request' : 'Continue'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentStepView(CertificateController controller) {
    switch (_currentStep) {
      case 1:
        return Step1TypeSelection(formKey: _step1Key, controller: controller);
      case 2:
        return Step2MedicalInfo(formKey: _step2Key, controller: controller);
      case 3:
        return Step3DocumentUpload(controller: controller);
      case 4:
        return Step4ReviewSubmit(
          controller: controller,
          confirmDisclaimer: _confirmDisclaimer,
          onDisclaimerChanged: (val) => setState(() => _confirmDisclaimer = val!),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _handleBackNavigation() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  void _handleNextStep(CertificateController controller) async {
    if (_currentStep == 1) {
      if (controller.selectedType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a certificate type'), behavior: SnackBarBehavior.floating),
        );
        return;
      }
      if (_step1Key.currentState?.validate() ?? false) {
        setState(() => _currentStep = 2);
      }
    } else if (_currentStep == 2) {
      if (_step2Key.currentState?.validate() ?? false) {
        setState(() => _currentStep = 3);
      }
    } else if (_currentStep == 3) {
      if (controller.getUploadedDoc('Profile Photo') == null ||
          controller.getUploadedDoc('Government ID Proof') == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload required verification files.'), behavior: SnackBarBehavior.floating),
        );
        return;
      }
      setState(() => _currentStep = 4);
    } else if (_currentStep == 4) {
      if (!_confirmDisclaimer) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please confirm accuracy verification to proceed.'), behavior: SnackBarBehavior.floating),
        );
        return;
      }

      final success = await controller.submitRequest();
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text('Certificate Request Dispatched!'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    }
  }
}