import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import 'widgets/certificate_action_form.dart';
import 'widgets/patient_info_panel.dart';
import 'widgets/certificate_review_shimmer.dart';

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

class _CertificateReviewScreenState extends ConsumerState<CertificateReviewScreen> {
  // ✅ ADDED: FormKey moved to UI state (fixes null crash)
  final _formKey = GlobalKey<FormState>();

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

    final isReadOnly = reviewState.detail?.isFinalized ?? false;
    final isSubmitting = reviewState.submitting;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppHeader(
        title: isReadOnly ? 'Certificate Details' : 'Review Request',
      ),
      body: reviewState.loading
          ? const CertificateReviewShimmer() // ✅ ADDED: Shimmer instead of spinner
          : reviewState.detail == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Certificate not found',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'The requested certificate could not be loaded',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      )
          : SafeArea(
        top: false,
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
              child: isMobile
                  ? Column(
                children: [
                  PatientInfoPanel(
                    certificate: reviewState.detail!,
                    documents: reviewState.documents,
                    isReadOnly: isReadOnly,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (!isReadOnly)
                  // ✅ ADDED: Form wrapper with local _formKey
                    Form(
                      key: _formKey,
                      child: CertificateActionForm(
                        certificate: reviewState.detail!,
                        notesController: notifier.notesController,
                        selectedFitnessStatus: reviewState.fitnessStatus,
                        validityPeriod: "${reviewState.validity} days",
                        isSubmitting: isSubmitting,
                        onFitnessStatusChanged: (value) {
                          notifier.changeFitnessStatus(value);
                        },
                        onValidityChanged: (value) {
                          if (value == null) return;
                          final days = int.parse(value.split(" ").first);
                          notifier.changeValidity(days);
                        },
                        onApprove: () async {
                          // ✅ FIXED: Null-safe validation
                          if (_formKey.currentState?.validate() != true) return;

                          final ok = await notifier.approve();
                          if (!context.mounted) return;

                          if (ok) {
                            await ref.read(doctorCertificateProvider.notifier).refresh();
                            if (!context.mounted) return;

                            _showSnackBar("Approved Successfully", isError: false);
                            context.pop();
                          } else {
                            _showSnackBar(
                              reviewState.errorMessage ?? "Approval Failed",
                              isError: true,
                            );
                          }
                        },
                        onReject: () async {
                          final ok = await notifier.reject();
                          if (!context.mounted) return;

                          if (ok) {
                            await ref.read(doctorCertificateProvider.notifier).refresh();
                            if (!context.mounted) return;

                            _showSnackBar("Rejected Successfully", isError: true);
                            context.pop();
                          } else {
                            _showSnackBar(
                              reviewState.errorMessage ?? "Rejection Failed",
                              isError: true,
                            );
                          }
                        },
                      ),
                    )
                  else
                    _buildReadOnlyStatus(context),
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
                      isReadOnly: isReadOnly,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    flex: 5,
                    child: isReadOnly
                        ? _buildReadOnlyStatus(context)
                        : // ✅ ADDED: Form wrapper with local _formKey
                    Form(
                      key: _formKey,
                      child: CertificateActionForm(
                        certificate: reviewState.detail!,
                        notesController: notifier.notesController,
                        selectedFitnessStatus: reviewState.fitnessStatus,
                        validityPeriod: "${reviewState.validity} days",
                        isSubmitting: isSubmitting,
                        onFitnessStatusChanged: notifier.changeFitnessStatus,
                        onValidityChanged: (v) {
                          if (v == null) return;
                          notifier.changeValidity(
                            int.parse(v.split(" ").first),
                          );
                        },
                        onApprove: () async {
                          // ✅ FIXED: Null-safe validation
                          if (_formKey.currentState?.validate() != true) return;

                          final ok = await notifier.approve();
                          if (!context.mounted) return;

                          if (ok) {
                            await ref.read(doctorCertificateProvider.notifier).refresh();
                            if (!context.mounted) return;

                            _showSnackBar("Certificate Approved", isError: false);
                            context.pop();
                          } else {
                            _showSnackBar(
                              reviewState.errorMessage ?? "Approval Failed",
                              isError: true,
                            );
                          }
                        },
                        onReject: () async {
                          final ok = await notifier.reject();
                          if (!context.mounted) return;

                          if (ok) {
                            await ref.read(doctorCertificateProvider.notifier).refresh();
                            if (!context.mounted) return;

                            _showSnackBar("Certificate Rejected", isError: true);
                            context.pop();
                          } else {
                            _showSnackBar(
                              reviewState.errorMessage ?? "Rejection Failed",
                              isError: true,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyStatus(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(doctorCertificateReviewProvider);

    final isFit = state.fitnessStatus.toUpperCase() == 'FIT';
    final statusColor = isFit ? colorScheme.primary : colorScheme.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            state.detail?.isApproved == true
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            size: 48,
            color: state.detail?.isApproved == true
                ? colorScheme.primary
                : colorScheme.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            state.detail?.isApproved == true
                ? 'Certificate Approved'
                : 'Certificate ${state.detail?.status.toUpperCase() ?? ''}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: state.detail?.isApproved == true
                  ? colorScheme.primary
                  : colorScheme.error,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (state.detail?.certificateId != null) ...[
            Text(
              'Certificate ID: ${state.detail!.certificateId}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (state.detail?.issuedAt != null) ...[
            Text(
              'Issued: ${_formatDate(state.detail!.issuedAt!)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (state.detail?.expiryDate != null) ...[
            Text(
              'Expires: ${_formatDate(state.detail!.expiryDate!)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            height: 1,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "Doctor's Notes",
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              state.detail?.doctorNotes?.isNotEmpty == true
                  ? state.detail!.doctorNotes!
                  : 'No notes provided',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "Fitness Status",
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isFit
                  ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFit
                      ? Icons.check_circle_outline_rounded
                      : Icons.warning_amber_rounded,
                  size: 16,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Text(
                  state.fitnessStatus.isNotEmpty ? state.fitnessStatus : 'N/A',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showSnackBar(String msg, {required bool isError}) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}