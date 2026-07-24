import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_certificate_detail_model.dart';
import 'status_chip_selector.dart';

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
  final ValueChanged<String> onFitnessStatusChanged;
  final ValueChanged<String?> onValidityChanged;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.transparency(0.35),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CERTIFICATE DETAILS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.transparency(0.6),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildStaticField(
                context,
                'Certificate Type',
                certificate.certificateType,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildStaticField(
                context,
                "Patient's Request Notes",
                certificate.notes.trim().isEmpty ? "N/A" : certificate.notes,
              ),
              const SizedBox(height: 20),
              Divider(
                color: colorScheme.outlineVariant.transparency(0.25),
                height: 1,
              ),
              const SizedBox(height: 20),
              _buildDropdownField(context),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'FITNESS ASSESSMENT',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.transparency(0.6),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              StatusChipSelector(
                selectedStatus: selectedFitnessStatus,
                onChanged: onFitnessStatusChanged,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildClinicalNotesField(context),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.transparency(0.35),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              _buildActionButtons(context),
              const SizedBox(height: AppSpacing.md),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Fields marked ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.transparency(0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: '* ',
                      style: TextStyle(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'are required. Approval will generate the certificate.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStaticField(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant.transparency(0.5),
            fontWeight: FontWeight.w800,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const validValues = ['7 days', '30 days', '90 days'];
    final safeValue = validValues.contains(validityPeriod) ? validityPeriod : '30 days';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'VALIDITY PERIOD',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.transparency(0.5),
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: safeValue,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
          dropdownColor: colorScheme.surfaceContainerHigh,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colorScheme.onSurfaceVariant.transparency(0.8),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surfaceContainerHigh,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
          ),
          items: const [
            DropdownMenuItem(value: "7 days", child: Text("7 Days")),
            DropdownMenuItem(value: "30 days", child: Text("30 Days")),
            DropdownMenuItem(value: "90 days", child: Text("90 Days")),
          ],
          onChanged: onValidityChanged,
        ),
      ],
    );
  }

  Widget _buildClinicalNotesField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "DOCTOR'S CLINICAL NOTES",
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.transparency(0.5),
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: notesController,
          maxLines: 4,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
          validator: (val) => val == null || val.trim().isEmpty
              ? 'Clinical findings required'
              : null,
          decoration: InputDecoration(
            hintText:
            'Add your clinical findings, observations and recommendations...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.transparency(0.45),
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHigh,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 46,
            child: FilledButton.icon(
              onPressed: isSubmitting ? null : onApprove,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shadowColor: Colors.transparent,
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
                  color: colorScheme.onPrimary,
                ),
              )
                  : const Icon(Icons.check_rounded, size: 16),
              label: Text(
                isSubmitting ? 'Processing...' : 'Approve & Generate',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onPrimary,
                  letterSpacing: 0.1,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 46,
            child: OutlinedButton.icon(
              onPressed: isSubmitting ? null : onReject,
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
                backgroundColor: colorScheme.errorContainer.withValues(
                  alpha: 0.2,
                ),
                elevation: 0,
                side: BorderSide(
                  color: colorScheme.error.transparency(0.25),
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
                  : const Icon(Icons.close_rounded, size: 16),
              label: Text(
                isSubmitting ? 'Processing...' : 'Reject',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.error,
                  letterSpacing: 0.1,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}