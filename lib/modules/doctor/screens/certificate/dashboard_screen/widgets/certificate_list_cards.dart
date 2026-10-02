import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/core/utils/responsive.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_certificate_request_model.dart';
import 'package:yodoctor/modules/widgets/status_chip.dart';

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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: certificates.length,
      itemBuilder: (context, index) {
        final cert = certificates[index];
        final isMobile = Responsive.isMobile(context);

        return isMobile
            ? _buildMobileCard(context, cert)
            : _buildDesktopCard(context, cert);
      },
    );
  }

  // 📱 MOBILE CARD LAYOUT
  Widget _buildMobileCard(
    BuildContext context,
    DoctorCertificateRequestModel cert,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(isIssuedTab ? cert.issuedAt ?? cert.createdAt : cert.createdAt);
    final expiryDate = DateFormat(
      'dd MMM yyyy',
    ).format(cert.expiryDate ?? DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  cert.fullName.isNotEmpty
                      ? cert.fullName.substring(0, 1).toUpperCase()
                      : 'U',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'ID: ${cert.id}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isIssuedTab) ...[
                const SizedBox(width: AppSpacing.xs),
                StatusChip(
                  status: cert.status.isNotEmpty
                      ? cert.status[0].toUpperCase() + cert.status.substring(1)
                      : '',
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Certificate Details Chips
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildTypeChip(context, cert.certificateType),
              _buildDateBadge(
                context,
                icon: Icons.calendar_today_rounded,
                label: formattedDate,
              ),
              if (isIssuedTab)
                _buildDateBadge(
                  context,
                  icon: Icons.timer_outlined,
                  label: 'Exp: $expiryDate',
                  isError: true,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Action Button
          _buildActionButton(context, theme, cert, width: double.infinity),
        ],
      ),
    );
  }

  // 💻 DESKTOP CARD LAYOUT
  Widget _buildDesktopCard(
    BuildContext context,
    DoctorCertificateRequestModel cert,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(isIssuedTab ? cert.issuedAt ?? cert.createdAt : cert.createdAt);
    final expiryDate = DateFormat(
      'dd MMM yyyy',
    ).format(cert.expiryDate ?? DateTime.now());

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // User Profile
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    cert.fullName.isNotEmpty
                        ? cert.fullName.substring(0, 1).toUpperCase()
                        : 'U',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${cert.id}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Type Column
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderLabel(context, 'CERTIFICATE TYPE'),
                const SizedBox(height: 6),
                _buildTypeChip(context, cert.certificateType),
              ],
            ),
          ),

          // Date Info Column
          Expanded(
            flex: 2,
            child: _buildInfoColumn(
              context,
              isIssuedTab ? 'ISSUED ON' : 'SUBMITTED',
              formattedDate,
            ),
          ),

          // Status / Expiry Column
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderLabel(
                  context,
                  isIssuedTab ? 'EXPIRES ON' : 'STATUS',
                ),
                const SizedBox(height: 6),
                isIssuedTab
                    ? Text(
                        expiryDate,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.error(context),
                        ),
                      )
                    : StatusChip(status: cert.status, isSmall: true),
              ],
            ),
          ),

          // Action Button
          _buildActionButton(context, theme, cert),
        ],
      ),
    );
  }

  // Helper Widget: Header Text Label
  Widget _buildHeaderLabel(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    );
  }

  // Helper Widget: Info Column
  Widget _buildInfoColumn(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderLabel(context, label),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  // Helper Widget: Action Button
  Widget _buildActionButton(
    BuildContext context,
    ThemeData theme,
    DoctorCertificateRequestModel certificate, {
    double? width,
  }) {
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: width,
      height: 42,
      child: FilledButton.icon(
        onPressed: () {
          if (isIssuedTab) {
            // View PDF logic
          } else {
            context.push(
              "${AppRoutes.doctorCertificateReview}/${certificate.id}",
            );
          }
        },
        icon: Icon(
          isIssuedTab ? Icons.picture_as_pdf_rounded : Icons.edit_note_rounded,
          size: 18,
        ),
        label: Text(
          isIssuedTab ? 'View PDF' : 'Review Request',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: isIssuedTab
              ? colorScheme.secondaryContainer
              : colorScheme.primary,
          foregroundColor: isIssuedTab
              ? colorScheme.onSecondaryContainer
              : colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
      ),
    );
  }

  // Helper Widget: Certificate Type Chip
  Widget _buildTypeChip(BuildContext context, String type) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // Helper Widget: Compact Date Badge
  Widget _buildDateBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isError = false,
  }) {
    final theme = Theme.of(context);

    final bg = isError
        ? AppTheme.error(context).withValues(alpha: 0.15)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);

    final fg = isError
        ? AppTheme.error(context)
        : theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
