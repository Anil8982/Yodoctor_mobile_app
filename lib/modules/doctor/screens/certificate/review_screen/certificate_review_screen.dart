import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import 'package:yodoctor/modules/widgets/app_snack_bar.dart';
import '../../../../../core/utils/app_spacing.dart';
import '../../../../../core/utils/responsive.dart';
import 'widgets/certificate_action_form.dart';
import 'widgets/patient_info_panel.dart';
import 'widgets/certificate_review_shimmer.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/doctor_certificate_controller.dart';
import '../../../controllers/doctor_certificate_review_controller.dart';

class CertificateReviewScreen extends ConsumerStatefulWidget {
  final int requestId;

  const CertificateReviewScreen({super.key, required this.requestId});

  @override
  ConsumerState<CertificateReviewScreen> createState() =>
      _CertificateReviewScreenState();
}

class _CertificateReviewScreenState
    extends ConsumerState<CertificateReviewScreen> {
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

    final isReadOnly = notifier.isFinalized();
    final isSubmitting = reviewState.submitting;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppHeader(
        title: isReadOnly ? 'Certificate Details' : 'Review Request',
      ),
      body: reviewState.loading
          ? const CertificateReviewShimmer()
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
                                Form(
                                  key: _formKey,
                                  child: CertificateActionForm(
                                    certificate: reviewState.detail!,
                                    notesController: notifier.notesController,
                                    selectedFitnessStatus:
                                        reviewState.fitnessStatus,
                                    validityPeriod:
                                        "${reviewState.validity} days",
                                    isSubmitting: isSubmitting,
                                    onFitnessStatusChanged: (value) {
                                      notifier.changeFitnessStatus(value);
                                    },
                                    onValidityChanged: notifier.changeValidity,
                                    onApprove: () async {
                                      if (_formKey.currentState?.validate() !=
                                          true) {
                                        return;
                                      }

                                      final ok = await notifier.approve();
                                      if (!context.mounted) return;

                                      if (ok) {
                                        await ref
                                            .read(
                                              doctorCertificateProvider
                                                  .notifier,
                                            )
                                            .refresh();
                                        if (!context.mounted) return;
                                        AppSnackBar.show(
                                          message: 'Approved Successfully',
                                          type: AppSnackBarType.success,
                                        );
                                        context.pop();
                                      } else {
                                        AppSnackBar.show(
                                          message:
                                              reviewState.errorMessage ??
                                              'Approval Failed',
                                          type: AppSnackBarType.error,
                                        );
                                      }
                                    },
                                    onReject: () async {
                                      final ok = await notifier.reject();
                                      if (!context.mounted) return;

                                      if (ok) {
                                        await ref
                                            .read(
                                              doctorCertificateProvider
                                                  .notifier,
                                            )
                                            .refresh();
                                        if (!context.mounted) return;
                                        AppSnackBar.show(
                                          message: 'Rejected Successfully',
                                          type: AppSnackBarType.success,
                                        );
                                        context.pop();
                                      } else {
                                        AppSnackBar.show(
                                          message:
                                              reviewState.errorMessage ??
                                              "Rejection Failed",
                                          type: AppSnackBarType.error,
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
                                    : Form(
                                        key: _formKey,
                                        child: CertificateActionForm(
                                          certificate: reviewState.detail!,
                                          notesController:
                                              notifier.notesController,
                                          selectedFitnessStatus:
                                              reviewState.fitnessStatus,
                                          validityPeriod:
                                              "${reviewState.validity} days",
                                          isSubmitting: isSubmitting,
                                          onFitnessStatusChanged:
                                              notifier.changeFitnessStatus,
                                          onValidityChanged:
                                              notifier.changeValidity,
                                          onApprove: () async {
                                            if (_formKey.currentState
                                                    ?.validate() !=
                                                true) {
                                              return;
                                            }

                                            final ok = await notifier.approve();
                                            if (!context.mounted) return;

                                            if (ok) {
                                              await ref
                                                  .read(
                                                    doctorCertificateProvider
                                                        .notifier,
                                                  )
                                                  .refresh();
                                              if (!context.mounted) return;
                                              AppSnackBar.show(
                                                message: 'Certificate Approved',
                                                type: AppSnackBarType.success,
                                              );
                                              context.pop();
                                            } else {
                                              AppSnackBar.show(
                                                message:
                                                    reviewState.errorMessage ??
                                                    "Approval Failed",
                                                type: AppSnackBarType.error,
                                              );
                                            }
                                          },
                                          onReject: () async {
                                            final ok = await notifier.reject();
                                            if (!context.mounted) return;

                                            if (ok) {
                                              await ref
                                                  .read(
                                                    doctorCertificateProvider
                                                        .notifier,
                                                  )
                                                  .refresh();
                                              if (!context.mounted) return;
                                              AppSnackBar.show(
                                                message: 'Certificate Rejected',
                                                type: AppSnackBarType.success,
                                              );
                                              context.pop();
                                            } else {
                                              AppSnackBar.show(
                                                message:
                                                    reviewState.errorMessage ??
                                                    "Rejection Failed",
                                                type: AppSnackBarType.error,
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

  // ✅ CUSTOM SOFT MEDICAL STYLED READONLY PANEL
  Widget _buildReadOnlyStatus(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(doctorCertificateReviewProvider);

    final statusStr = state.detail?.status.trim().toUpperCase() ?? '';
    final isApproved =
        state.detail?.isApproved == true ||
        statusStr == 'APPROVED' ||
        statusStr == 'ISSUED';
    final isRejected = statusStr == 'REJECTED' || statusStr == 'CANCELLED';

    // Status Theme Dynamic Colors
    final Color statusBg = isApproved
        ? (isDark ? const Color(0xFF132E23) : const Color(0xFFE8F5E9))
        : isRejected
        ? (isDark ? const Color(0xFF331619) : const Color(0xFFFFEBEE))
        : (isDark ? const Color(0xFF332712) : const Color(0xFFFFF8E1));

    final Color statusFg = isApproved
        ? (isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32))
        : isRejected
        ? (isDark ? const Color(0xFFE57373) : const Color(0xFFC62828))
        : (isDark ? const Color(0xFFFFD54F) : const Color(0xFFE65100));

    final IconData statusIcon = isApproved
        ? Icons.check_circle_rounded
        : isRejected
        ? Icons.cancel_rounded
        : Icons.hourglass_full_rounded;

    // Fitness Status Dynamic Colors
    final isFit = state.fitnessStatus.toUpperCase() == 'FIT';
    final fitnessBg = isFit
        ? (isDark ? const Color(0xFF132E23) : const Color(0xFFE8F5E9))
        : (isDark ? const Color(0xFF331619) : const Color(0xFFFFEBEE));
    final fitnessFg = isFit
        ? (isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32))
        : (isDark ? const Color(0xFFE57373) : const Color(0xFFC62828));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(statusIcon, size: 32, color: statusFg),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Certificate ${statusStr.toLowerCase()}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: statusFg,
                      ),
                    ),
                    if (state.detail?.certificateId != null)
                      Text(
                        'ID: ${state.detail!.certificateId}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.detail?.issuedAt != null ||
              state.detail?.expiryDate != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E2124)
                    : const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (state.detail?.issuedAt != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ISSUED DATE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(state.detail!.issuedAt!),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (state.detail?.expiryDate != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXPIRATION DATE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(state.detail!.expiryDate!),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: statusFg,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          Text(
            "DOCTOR'S REMARKS",
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2124) : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              state.detail?.doctorNotes?.isNotEmpty == true
                  ? state.detail!.doctorNotes!
                  : 'No remarks recorded',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "FITNESS ASSESSMENT",
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: fitnessBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFit
                      ? Icons.check_circle_outline_rounded
                      : Icons.warning_amber_rounded,
                  size: 16,
                  color: fitnessFg,
                ),
                const SizedBox(width: 8),
                Text(
                  state.fitnessStatus.isNotEmpty ? state.fitnessStatus : 'N/A',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: fitnessFg,
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
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
