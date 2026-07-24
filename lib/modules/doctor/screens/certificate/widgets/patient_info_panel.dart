import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_certificate_detail_model.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_document_model.dart';
import 'document_preview_tile.dart';

class PatientInfoPanel extends StatelessWidget {
  const PatientInfoPanel({
    super.key,
    required this.certificate,
    required this.documents,
    this.isReadOnly = false,
  });

  final DoctorCertificateDetailModel certificate;
  final List<DoctorDocumentModel> documents;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.transparency(.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      certificate.initials,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          certificate.fullName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID : ${certificate.id}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isReadOnly) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: certificate.isApproved
                            ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                            : colorScheme.errorContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        certificate.status.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: certificate.isApproved
                              ? colorScheme.primary
                              : colorScheme.error,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 20),
              Divider(
                color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                height: 1,
              ),
              const SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 3.0,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                children: [
                  _buildInternalRow(
                    context,
                    Icons.calendar_today_rounded,
                    'DOB',
                    certificate.formattedDob,
                  ),
                  _buildInternalRow(
                    context,
                    Icons.wc_rounded,
                    'GENDER',
                    certificate.gender,
                  ),
                  _buildInternalRow(
                    context,
                    Icons.assignment_rounded,
                    'CERTIFICATE',
                    certificate.certificateType,
                  ),
                  _buildInternalRow(
                    context,
                    Icons.flag_rounded,
                    'PURPOSE',
                    certificate.purpose,
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Divider(
                color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                height: 1,
              ),
              const SizedBox(height: 20),

              // ✅ Clinical complaints with N/A fallback
              Text(
                'CLINICAL COMPLAINTS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                certificate.medicalConditions.trim().isEmpty
                    ? "N/A"
                    : certificate.medicalConditions,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // ✅ Documents section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'UPLOADED DOCUMENTS (${documents.length})',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              if (documents.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${documents.length} file${documents.length > 1 ? 's' : ''}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        if (documents.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'No documents uploaded',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else
          ...documents.map((doc) {
            return DocumentPreviewTile(document: doc);
          }),

        const SizedBox(height: 20),

        // ✅ Current Medications
        Text(
          'CURRENT MEDICATIONS',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          certificate.medications.trim().isEmpty ? "N/A" : certificate.medications,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 20),

        // ✅ Patient Notes
        Text(
          'PATIENT NOTES',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          certificate.notes.trim().isEmpty ? "N/A" : certificate.notes,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        // ✅ If approved, show additional certificate info
        if (certificate.isApproved && isReadOnly) ...[
          const SizedBox(height: 20),
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            height: 1,
          ),
          const SizedBox(height: 20),

          // ✅ Certificate ID
          if (certificate.certificateId != null) ...[
            Text(
              'CERTIFICATE ID',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                certificate.certificateId!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                  fontFamily: 'Courier',
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // ✅ Doctor Notes
          Text(
            "DOCTOR'S NOTES",
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            certificate.doctorNotes?.trim().isNotEmpty == true
                ? certificate.doctorNotes!
                : 'No notes provided',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Fitness Status
          Text(
            "FITNESS STATUS",
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: certificate.fitnessStatus?.toUpperCase().contains('FIT') == true
                  ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              certificate.fitnessStatus ?? 'N/A',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: certificate.fitnessStatus?.toUpperCase().contains('FIT') == true
                    ? colorScheme.primary
                    : colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInternalRow(
      BuildContext context,
      IconData icon,
      String label,
      String value,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}