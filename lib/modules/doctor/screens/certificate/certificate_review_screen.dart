import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import 'widgets/certificate_action_form.dart';
import 'widgets/patient_info_panel.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/doctor_certificate_controller.dart';
import '../../controllers/doctor_certificate_review_controller.dart';

class CertificateReviewScreen extends ConsumerStatefulWidget {
  final int requestId;

  const CertificateReviewScreen({super.key, required this.requestId});

  @override
  ConsumerState<CertificateReviewScreen> createState() =>
      _CertificateReviewScreenState();
}

class _CertificateReviewScreenState
    extends ConsumerState<CertificateReviewScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(doctorCertificateReviewProvider.notifier).load(widget.requestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = Responsive.isMobile(context);
    final double hPadding = Responsive.horizontalPadding(context);
    final reviewState = ref.watch(doctorCertificateReviewProvider);

    final notifier = ref.read(doctorCertificateReviewProvider.notifier);

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
      body: reviewState.loading
          ? const Center(child: CircularProgressIndicator())
          : reviewState.detail == null
          ? const Center(child: Text("Certificate not found"))
          : SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      hPadding,
                      AppSpacing.xl,
                      hPadding,
                      AppSpacing.xxxl,
                    ),
                    child: Form(
                      key: notifier.formKey,
                      child: isMobile
                          ? Column(
                              children: [
                                PatientInfoPanel(
                                  certificate: reviewState.detail!,
                                  documents: reviewState.documents,
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                CertificateActionForm(
                                  certificate: reviewState.detail!,
                                  notesController: notifier.notesController,
                                  selectedFitnessStatus: notifier.fitnessStatus,
                                  validityPeriod: "${notifier.validity} days",
                                  onFitnessStatusChanged: (value) {
                                    notifier.changeFitnessStatus(value);
                                  },
                                  onValidityChanged: (value) {
                                    if (value == null) return;

                                    final days = int.parse(
                                      value.split(" ").first,
                                    );

                                    notifier.changeValidity(days);
                                  },
                                  onApprove: () async {
                                    final ok = await notifier.approve();

                                    if (!context.mounted) return;

                                    if (ok) {
                                      _showSnackBar(
                                        "Approved Successfully",
                                        isError: false,
                                      );

                                      context.pop();
                                    }
                                  },
                                  onReject: () async {
                                    final ok = await notifier.reject();

                                    if (!context.mounted) return;

                                    if (ok) {
                                      _showSnackBar("Rejected", isError: true);

                                      context.pop();
                                    }
                                  },
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: PatientInfoPanel(
                                    certificate: reviewState.detail!,
                                    documents: reviewState.documents,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  flex: 5,
                                  child: CertificateActionForm(
                                    certificate: reviewState.detail!,
                                    notesController: notifier.notesController,

                                    selectedFitnessStatus:
                                        notifier.fitnessStatus,

                                    validityPeriod: "${notifier.validity} days",

                                    onFitnessStatusChanged:
                                        notifier.changeFitnessStatus,

                                    onValidityChanged: (v) {
                                      if (v == null) return;

                                      notifier.changeValidity(
                                        int.parse(v.split(" ").first),
                                      );
                                    },

                                    onApprove: () async {
                                      if (!notifier.formKey.currentState!
                                          .validate()) {
                                        return;
                                      }

                                      if (!context.mounted) return;

                                      await notifier.approve();

                                      await ref
                                          .read(
                                            doctorCertificateProvider.notifier,
                                          )
                                          .refresh();

                                      if (!context.mounted) return;

                                      _showSnackBar(
                                        "Certificate Approved",
                                        isError: false,
                                      );

                                      context.pop();
                                    },

                                    onReject: () async {
                                      if (!context.mounted) return;

                                      await notifier.reject();

                                      await ref
                                          .read(
                                            doctorCertificateProvider.notifier,
                                          )
                                          .refresh();

                                      if (!context.mounted) return;

                                      _showSnackBar(
                                        "Certificate Rejected",
                                        isError: true,
                                      );

                                      context.pop();
                                    },
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

  // void _approveCertificateWithState(dynamic controller) {
  //   if (_selectedFitnessStatus.isEmpty) {
  //     _showSnackBar('Please select fitness status', isError: true);
  //     return;
  //   }
  //   if (!_formKey.currentState!.validate()) return;
  //   _showSnackBar('Certificate Approved & Generated successfully', isError: false);
  //   context.pop();
  // }

  void _showSnackBar(String msg, {required bool isError}) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isError
                ? colorScheme.onErrorContainer
                : colorScheme.onPrimaryContainer,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError
            ? colorScheme.errorContainer
            : colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}
