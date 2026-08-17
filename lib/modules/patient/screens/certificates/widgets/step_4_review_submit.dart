import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'step_header_helper.dart';

class Step4ReviewSubmit extends ConsumerWidget {
  final CertificateNotifier controller;
  final bool confirmDisclaimer;
  final ValueChanged<bool?> onDisclaimerChanged;

  const Step4ReviewSubmit({
    super.key,
    required this.controller,
    required this.confirmDisclaimer,
    required this.onDisclaimerChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch current form state reactively from provider
    final formState = ref.watch(certificateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepHeader(
          title: 'Review Application',
          desc:
              'Confirm accuracy of entries before submitting to evaluation channels.',
        ),
        const SizedBox(height: 20),
        _buildReviewListCard(
          context,
          title: 'Certificate Baseline Parameters',
          items: [
            {
              'label': 'Certificate Type',
              'value': formState.selectedType ?? 'N/A',
            },
            {
              'label': 'Assigned Medical Doctor',
              'value': formState.assignedDoctor?.name ?? 'N/A',
            },
            {
              'label': 'Medical Specialty',
              'value': formState.assignedDoctor?.specialty ?? 'N/A',
            },
            {'label': 'Intended Purpose', 'value': formState.purpose ?? 'N/A'},
            {
              'label': 'Additional Context Notes',
              'value': controller.additionalNotesController.text.isNotEmpty
                  ? controller.additionalNotesController.text
                  : 'None',
            },
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewListCard(
          context,
          title: 'Patient Diagnostic Information',
          items: [
            {
              'label': 'Full Legal Name',
              'value': controller.fullNameController.text,
            },
            {
              'label': 'Date of Birth',
              'value': formState.dateOfBirth != null
                  ? '${formState.dateOfBirth!.day.toString().padLeft(2, '0')}-'
                        '${formState.dateOfBirth!.month.toString().padLeft(2, '0')}-'
                        '${formState.dateOfBirth!.year}'
                  : 'N/A',
            },
            {'label': 'Biological Gender', 'value': formState.gender ?? 'N/A'},
            {'label': 'Blood Group Staging', 'value': formState.bloodGroup},
            {
              'label': 'Height Metric',
              'value': controller.heightController.text.isNotEmpty
                  ? '${controller.heightController.text} cm'
                  : 'N/A',
            },
            {
              'label': 'Weight Metric',
              'value': controller.weightController.text.isNotEmpty
                  ? '${controller.weightController.text} kg'
                  : 'N/A',
            },
            {
              'label': 'Chronic Medical Conditions',
              'value': controller.medicalConditionsController.text.isNotEmpty
                  ? controller.medicalConditionsController.text
                  : 'None',
            },
            {
              'label': 'Current Active Prescriptions',
              'value': controller.medicationsController.text.isNotEmpty
                  ? controller.medicationsController.text
                  : 'None',
            },
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Uploaded Verification Materials',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        _buildDocumentReviewRow(context, formState),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.gavel_rounded, color: colorScheme.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'By dispatching this electronic request profile, you explicitly affirm that all biometric info matches verified personal medical tracking history.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Theme(
          data: theme.copyWith(
            checkboxTheme: theme.checkboxTheme.copyWith(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          child: CheckboxListTile(
            value: confirmDisclaimer,
            onChanged: onDisclaimerChanged,
            title: Text(
              'I legally verify that my submitted profile fields are accurate.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewListCard(
    BuildContext context, {
    required String title,
    required List<Map<String, String>> items,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              height: 24,
            ),
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      items[index]['label']!.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 10,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: Text(
                      items[index]['value']!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentReviewRow(
      BuildContext context,
      CertificateFormState formState,
      ) {
    final docs = [
      'Profile Photo',
      'Government ID Proof',
      'Medical Reports',
      'Prescription',
    ];

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: docs.map((docKey) {
        final fileName = formState.uploadedDocs[docKey];

        if (fileName == null) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(14),
            color: colorScheme.surface,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                ),
                child: Center(
                  child: Icon(
                    Icons.description_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      docKey,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
