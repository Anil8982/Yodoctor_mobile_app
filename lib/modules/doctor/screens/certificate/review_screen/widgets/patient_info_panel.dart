import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_certificate_detail_model.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_document_model.dart';
import 'package:yodoctor/modules/widgets/status_chip.dart';
import '../../dashboard_screen/widgets/document_preview_tile.dart';

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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          // Header with initials and name
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  certificate.initials.isNotEmpty ? certificate.initials : 'P',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificate.fullName.isNotEmpty ? certificate.fullName : 'Patient Name',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${certificate.id}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (isReadOnly) ...[
                StatusChip(
                  status: certificate.status.isNotEmpty
                      ? certificate.status[0].toUpperCase() + certificate.status.substring(1)
                      : 'Pending',
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 24),

          // Patient details grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 3.2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            children: [
              _buildInfoRow(
                context,
                Icons.calendar_today_rounded,
                'DOB',
                certificate.formattedDob.isNotEmpty ? certificate.formattedDob : 'N/A',
              ),
              _buildInfoRow(
                context,
                Icons.wc_rounded,
                'GENDER',
                certificate.gender.isNotEmpty ? certificate.gender : 'N/A',
              ),
              _buildInfoRow(
                context,
                Icons.assignment_rounded,
                'CERTIFICATE',
                certificate.certificateType.isNotEmpty ? certificate.certificateType : 'N/A',
              ),
              _buildInfoRow(
                context,
                Icons.flag_rounded,
                'PURPOSE',
                certificate.purpose.isNotEmpty ? certificate.purpose : 'N/A',
              ),
            ],
          ),

          const SizedBox(height: 24),
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 24),

          // Clinical complaints
          _buildSectionLabel(context, 'CLINICAL COMPLAINTS', Icons.medical_information_rounded),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              certificate.medicalConditions.trim().isEmpty
                  ? "N/A"
                  : certificate.medicalConditions,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Documents section
          _buildSectionLabel(context, 'UPLOADED DOCUMENTS (${documents.length})', Icons.folder_rounded),
          const SizedBox(height: 8),

          if (documents.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                ),
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
            Column(
              children: documents.map((doc) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DocumentPreviewTile(document: doc),
                );
              }).toList(),
            ),

          const SizedBox(height: 24),
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 24),

          // Current Medications
          _buildSectionLabel(context, 'CURRENT MEDICATIONS', Icons.medication_rounded),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              certificate.medications.trim().isEmpty ? "N/A" : certificate.medications,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Patient Notes
          _buildSectionLabel(context, 'PATIENT NOTES', Icons.note_alt_rounded),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              certificate.notes.trim().isEmpty ? "N/A" : certificate.notes,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // If approved, show additional certificate info
          if (certificate.isApproved && isReadOnly) ...[
            const SizedBox(height: 24),
            Divider(
              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              height: 1,
            ),
            const SizedBox(height: 24),

            // Certificate ID
            if (certificate.certificateId != null && certificate.certificateId!.isNotEmpty) ...[
              _buildSectionLabel(context, 'CERTIFICATE ID', Icons.assignment_rounded),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  certificate.certificateId!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                    fontFamily: 'Courier',
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Doctor's Notes
            _buildSectionLabel(context, "DOCTOR'S NOTES", Icons.notes_rounded),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                certificate.doctorNotes?.trim().isNotEmpty == true
                    ? certificate.doctorNotes!
                    : 'No notes provided',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fitness Status
            _buildSectionLabel(context, 'FITNESS STATUS', Icons.health_and_safety_rounded),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: StatusChip(
                status: certificate.fitnessStatus?.isNotEmpty == true ? certificate.fitnessStatus! : 'fit',
                isSmall: true,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      BuildContext context,
      IconData icon,
      String label,
      String value,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          Icon(
            icon,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}