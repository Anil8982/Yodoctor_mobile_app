import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/core/utils/responsive.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_certificate_request_model.dart';

/// Certificate list widget that uses ListView.builder with shrinkWrap
/// for safe usage inside Column/CustomScrollView with SliverToBoxAdapter.
class CertificateListCards extends StatelessWidget {
  const CertificateListCards({
    super.key,
    required this.certificates,
    required this.isIssuedTab,
  });

  final List<DoctorCertificateRequestModel> certificates;
  final bool isIssuedTab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = Responsive.isMobile(context);

    // ✅ Fixed: Using ListView.builder with shrinkWrap for safe Box layout
    // Suitable for use inside Column with SliverToBoxAdapter
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        final cert = certificates[index];
        final formattedDate = DateFormat('dd MMM yyyy').format(
          isIssuedTab ? cert.issuedAt ?? cert.createdAt : cert.createdAt,
        );
        final expiryDate = DateFormat(
          'dd MMM yyyy',
        ).format(cert.expiryDate ?? DateTime.now());

        if (isMobile) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: colorScheme.primary,
                      child: Text(
                        cert.fullName.substring(0, 1).toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.fullName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            cert.id.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.7,
                              ),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isIssuedTab) _buildStatusChip(context, cert.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _buildTypeChip(context, cert.certificateType),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formattedDate,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isIssuedTab)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.running_with_errors_rounded,
                              size: 12,
                              color: colorScheme.error,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Exp: $expiryDate',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.error,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildActionButton(
                  context,
                  theme,
                  cert,
                  width: double.infinity,
                ),
              ],
            ),
          );
        }

        // Desktop layout
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: colorScheme.primary,
                      child: Text(
                        cert.fullName.substring(0, 1).toUpperCase(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.fullName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cert.id.toString(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CERTIFICATE TYPE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildTypeChip(context, cert.certificateType),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildInfoColumn(
                  context,
                  isIssuedTab ? 'ISSUED ON' : 'SUBMITTED',
                  formattedDate,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isIssuedTab ? 'EXPIRES ON' : 'STATUS',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    isIssuedTab
                        ? Text(
                      expiryDate,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.error,
                      ),
                    )
                        : _buildStatusChip(context, cert.status),
                  ],
                ),
              ),
              _buildActionButton(context, theme, cert),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoColumn(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context,
      ThemeData theme,
      DoctorCertificateRequestModel certificate, {
        double? width,
      }) {
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: width,
      height: 44,
      child: FilledButton(
        onPressed: isIssuedTab
            ? null
            : () => context.push("${AppRoutes.doctorCertificateReview}/${certificate.id}"),
        style: FilledButton.styleFrom(
          backgroundColor: isIssuedTab
              ? colorScheme.secondaryContainer
              : colorScheme.primary,
          foregroundColor: isIssuedTab
              ? colorScheme.onSecondaryContainer
              : colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(
            color: isIssuedTab
                ? colorScheme.outlineVariant.withValues(alpha: 0.9)
                : Colors.transparent,
            width: 1.2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isIssuedTab ? Icons.arrow_downward_rounded : Icons.edit_document,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              isIssuedTab ? 'View PDF' : 'Review Request',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.1,
                color: isIssuedTab
                    ? colorScheme.onSecondaryContainer
                    : colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context, String type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isVerification = status.toUpperCase() == 'VERIFICATION';

    final baseColor = isVerification ? colorScheme.tertiary : colorScheme.error;
    final containerColor = isVerification
        ? colorScheme.tertiaryContainer
        : colorScheme.errorContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelSmall?.copyWith(
          color: baseColor,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}