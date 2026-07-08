import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'document_preview_tile.dart';
import '../../../../../core/models/doctor/doctor_certificate_detail_model.dart';
import '../../../../../core/models/doctor/doctor_document_model.dart';

class PatientInfoPanel extends StatelessWidget {
  const PatientInfoPanel({
    super.key,

    required this.certificate,

    required this.documents,
  });
  final DoctorCertificateDetailModel certificate;

  final List<DoctorDocumentModel> documents;
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
                      certificate.fullName.substring(0, 1).toUpperCase(),
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
                    certificate.dob != null
                        ? "${certificate.dob!.day}/${certificate.dob!.month}/${certificate.dob!.year}"
                        : "N/A",
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
                certificate.medicalConditions,
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            'UPLOADED DOCUMENTS (${documents.length})',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...documents.map((doc) {
          return DocumentPreviewTile(fileName: doc.fileName);
        }),

        const SizedBox(height: 20),

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
          certificate.medications.isEmpty ? "N/A" : certificate.medications,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 20),

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
          certificate.notes.isEmpty ? "N/A" : certificate.notes,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
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
