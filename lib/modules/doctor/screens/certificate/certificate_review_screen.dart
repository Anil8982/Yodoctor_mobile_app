import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/dummy_data.dart';
import '../../../../core/utils/responsive.dart';
import 'widgets/certificate_action_form.dart';
import 'widgets/patient_info_panel.dart';

class CertificateReviewScreen extends StatefulWidget {
  const CertificateReviewScreen({super.key});

  @override
  State<CertificateReviewScreen> createState() => _CertificateReviewScreenState();
}

class _CertificateReviewScreenState extends State<CertificateReviewScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();
  String _selectedFitnessStatus = '';
  String _validityPeriod = '1 month';

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = Responsive.isMobile(context);
    final double hPadding = Responsive.horizontalPadding(context);
    final certificate = DummyData.dummyCertificates.first;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(
          'Review Request',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        // dividerColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(hPadding, AppSpacing.xl, hPadding, AppSpacing.xxxl),
              child: Form(
                key: _formKey,
                child: isMobile
                    ? Column(
                  children: [
                    PatientInfoPanel(certificate: certificate),
                    const SizedBox(height: AppSpacing.lg),
                    CertificateActionForm(
                      certificate: certificate,
                      notesController: _notesController,
                      selectedFitnessStatus: _selectedFitnessStatus,
                      validityPeriod: _validityPeriod,
                      onFitnessStatusChanged: (status) {
                        setState(() => _selectedFitnessStatus = status);
                      },
                      onValidityChanged: (val) {
                        if (val == null) return;
                        setState(() => _validityPeriod = val);
                      },
                      onApprove: _approveCertificate,
                      onReject: _rejectCertificate,
                    ),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: PatientInfoPanel(certificate: certificate),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      flex: 5,
                      child: CertificateActionForm(
                        certificate: certificate,
                        notesController: _notesController,
                        selectedFitnessStatus: _selectedFitnessStatus,
                        validityPeriod: _validityPeriod,
                        onFitnessStatusChanged: (status) {
                          setState(() => _selectedFitnessStatus = status);
                        },
                        onValidityChanged: (val) {
                          if (val == null) return;
                          setState(() => _validityPeriod = val);
                        },
                        onApprove: _approveCertificate,
                        onReject: _rejectCertificate,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _approveCertificate() {
    if (_selectedFitnessStatus.isEmpty) {
      _showSnackBar('Please select fitness status', isError: true);
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    _showSnackBar('Certificate Approved & Generated successfully', isError: false);
    context.pop();
  }

  // void _approveCertificateWithState(dynamic controller) {
  //   if (_selectedFitnessStatus.isEmpty) {
  //     _showSnackBar('Please select fitness status', isError: true);
  //     return;
  //   }
  //   if (!_formKey.currentState!.validate()) return;
  //   _showSnackBar('Certificate Approved & Generated successfully', isError: false);
  //   context.pop();
  // }

  void _rejectCertificate() {
    _showSnackBar('Certificate Request Rejected', isError: true);
    context.pop();
  }

  void _showSnackBar(String msg, {required bool isError}) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isError ? colorScheme.onErrorContainer : colorScheme.onPrimaryContainer,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? colorScheme.errorContainer : colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}