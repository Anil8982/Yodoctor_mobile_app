import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/controllers/doctor_certificate_review_controller.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_certificate_detail_model.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';

class CertificateActionForm extends StatelessWidget {
  const CertificateActionForm({
    super.key,
    required this.certificate,
    required this.notesController,
    required this.selectedFitnessStatus,
    required this.validityPeriod,
    required this.isSubmitting,
    required this.onFitnessStatusChanged,
    required this.onValidityChanged,
    required this.onApprove,
    required this.onReject,
  });

  final DoctorCertificateDetailModel certificate;
  final TextEditingController notesController;
  final String selectedFitnessStatus;
  final String validityPeriod;
  final bool isSubmitting;
  final ValueChanged<String?> onFitnessStatusChanged;
  final ValueChanged<String?> onValidityChanged;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Form Container - Same style as PatientInfoPanel
        Container(
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
              // Header
              _buildSectionLabel(
                context,
                'CERTIFICATE DETAILS',
                Icons.assignment_rounded,
              ),
              const SizedBox(height: 20),
              Divider(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                height: 1,
              ),
              const SizedBox(height: 20),

              // Certificate Type (read-only)
              _buildInfoField(
                context,
                label: 'Certificate Type',
                value: certificate.certificateType.isNotEmpty
                    ? certificate.certificateType
                    : 'N/A',
                icon: Icons.description_rounded,
              ),
              const SizedBox(height: 16),

              // Patient's Request Notes (read-only)
              _buildInfoField(
                context,
                label: "Patient's Request Notes",
                value: certificate.notes.trim().isEmpty
                    ? "N/A"
                    : certificate.notes,
                icon: Icons.note_alt_rounded,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Divider(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                height: 1,
              ),
              const SizedBox(height: 20),

              // Validity Period Dropdown
              AppDropdownField<String>(
                label: 'VALIDITY PERIOD',
                isRequired: true,
                hint: 'Select validity period',
                icon: Icons.calendar_today_rounded,
                value:
                    CertificateConstants.validityPeriods.contains(
                      validityPeriod.trim(),
                    )
                    ? validityPeriod.trim()
                    : null,
                items: CertificateConstants.validityPeriods,
                itemLabelBuilder: (item) => item,
                onChanged: onValidityChanged,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Validity period is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Fitness Status Dropdown
              AppDropdownField<String>(
                label: 'FITNESS STATUS',
                isRequired: true,
                hint: 'Select fitness assessment status',
                icon: Icons.health_and_safety_rounded,
                value:
                    CertificateConstants.fitnessStatuses.contains(
                      selectedFitnessStatus.trim(),
                    )
                    ? selectedFitnessStatus.trim()
                    : null,
                items: CertificateConstants.fitnessStatuses,
                itemLabelBuilder: (item) => item,
                onChanged: onFitnessStatusChanged,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Fitness status is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Doctor's Clinical Notes
              AppTextField(
                label: "DOCTOR'S CLINICAL NOTES",
                isRequired: true,
                hint:
                    'Add your clinical findings, observations and recommendations...',
                icon: Icons.notes_rounded,
                controller: notesController,
                minLines: 3,
                maxLines: 5,
                maxLength: 2000,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Clinical findings required'
                    : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Action Buttons Container - Same style as main container but without top padding
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Primary Approve Button
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: isSubmitting ? null : onApprove,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 0,
                    shadowColor: AppTheme.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: isSubmitting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : const Icon(Icons.verified_rounded, size: 20),
                  label: Text(
                    isSubmitting
                        ? 'Processing Request...'
                        : 'Approve & Generate Certificate',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onPrimary,
                      letterSpacing: 0.2,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Secondary Reject Button (Subtle, clean outline look)
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: isSubmitting ? null : onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    backgroundColor: colorScheme.errorContainer.withValues(
                      alpha: 0.08,
                    ),
                    elevation: 0,
                    side: BorderSide(
                      color: colorScheme.error.withValues(alpha: 0.25),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: isSubmitting
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.error,
                          ),
                        )
                      : const Icon(Icons.close_rounded, size: 18),
                  label: Text(
                    'Reject Request',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.error,
                      letterSpacing: 0.2,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Requirement Instruction Note
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Fields marked with ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: '* ',
                          style: TextStyle(
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const TextSpan(text: 'are required before processing.'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontWeight: FontWeight.w800,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.15),
            ),
          ),
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              height: maxLines > 1 ? 1.5 : 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
