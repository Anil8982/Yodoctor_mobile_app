import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
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

  String _getLocalizedCertType(String? key, AppLocalizations l10n) {
    if (key == null) return l10n.notAvailableLabel;
    switch (key) {
      case 'Medical Fitness':
        return l10n.certMedicalFitness;
      case 'Vaccination':
        return l10n.certVaccination;
      case 'Disability':
        return l10n.certDisability;
      case 'Second Opinion':
        return l10n.certSecondOpinion;
      case 'Discharge Summary':
        return l10n.certDischargeSummary;
      default:
        return key;
    }
  }

  String _getLocalizedPurpose(String? purpose, AppLocalizations l10n) {
    if (purpose == null) return l10n.notAvailableLabel;
    switch (purpose) {
      case 'Travel':
        return l10n.purposeTravel;
      case 'Employment':
        return l10n.purposeEmployment;
      case 'Sports':
        return l10n.purposeSports;
      case 'School/University':
        return l10n.purposeSchoolUniversity;
      case 'Insurance':
        return l10n.purposeInsurance;
      case 'Other':
        return l10n.purposeOther;
      default:
        return purpose;
    }
  }

  String _getLocalizedGender(String? gender, AppLocalizations l10n) {
    if (gender == null) return l10n.notAvailableLabel;
    switch (gender) {
      case 'Male':
        return l10n.genderMale;
      case 'Female':
        return l10n.genderFemale;
      case 'Other':
        return l10n.genderOther;
      default:
        return gender;
    }
  }

  String _getLocalizedDocName(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Profile Photo':
        return l10n.docProfilePhoto;
      case 'Government ID Proof':
        return l10n.docGovtId;
      case 'Medical Reports':
        return l10n.docMedicalReports;
      case 'Prescription':
        return l10n.docPrescription;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // Watch current form state reactively from provider
    final formState = ref.watch(certificateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepHeader(
          title: l10n.reviewApplication,
          desc: l10n.reviewApplicationDesc,
        ),
        const SizedBox(height: 20),
        _buildReviewListCard(
          context,
          title: l10n.certificateBaselineParameters,
          items: [
            {
              'label': l10n.certificateTypeLabel,
              'value': _getLocalizedCertType(formState.selectedType, l10n),
            },
            {
              'label': l10n.assignedDoctorLabel,
              'value': formState.assignedDoctor?.name ?? l10n.notAvailableLabel,
            },
            {
              'label': l10n.medicalSpecialtyLabel,
              'value': formState.assignedDoctor?.specialty ?? l10n.notAvailableLabel,
            },
            {
              'label': l10n.intendedPurposeLabel,
              'value': _getLocalizedPurpose(formState.purpose, l10n),
            },
            {
              'label': l10n.additionalNotesLabel,
              'value': controller.additionalNotesController.text.isNotEmpty
                  ? controller.additionalNotesController.text
                  : l10n.noneLabel,
            },
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewListCard(
          context,
          title: l10n.patientDiagnosticInformation,
          items: [
            {
              'label': l10n.fullLegalNameLabel,
              'value': controller.fullNameController.text.isNotEmpty
                  ? controller.fullNameController.text
                  : l10n.notAvailableLabel,
            },
            {
              'label': l10n.dateOfBirthLabel,
              'value': formState.dateOfBirth != null
                  ? '${formState.dateOfBirth!.day.toString().padLeft(2, '0')}-'
                        '${formState.dateOfBirth!.month.toString().padLeft(2, '0')}-'
                        '${formState.dateOfBirth!.year}'
                  : l10n.notAvailableLabel,
            },
            {
              'label': l10n.biologicalGenderLabel,
              'value': _getLocalizedGender(formState.gender, l10n),
            },
            {
              'label': l10n.bloodGroupStagingLabel,
              'value': formState.bloodGroup,
            },
            {
              'label': l10n.heightMetricLabel,
              'value': controller.heightController.text.isNotEmpty
                  ? '${controller.heightController.text} cm'
                  : l10n.notAvailableLabel,
            },
            {
              'label': l10n.weightMetricLabel,
              'value': controller.weightController.text.isNotEmpty
                  ? '${controller.weightController.text} kg'
                  : l10n.notAvailableLabel,
            },
            {
              'label': l10n.chronicMedicalConditionsLabel,
              'value': controller.medicalConditionsController.text.isNotEmpty
                  ? controller.medicalConditionsController.text
                  : l10n.noneLabel,
            },
            {
              'label': l10n.activePrescriptionsLabel,
              'value': controller.medicationsController.text.isNotEmpty
                  ? controller.medicationsController.text
                  : l10n.noneLabel,
            },
          ],
        ),
        const SizedBox(height: 20),
        Text(
          l10n.uploadedVerificationMaterials,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        _buildDocumentReviewRow(context, formState, l10n),
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
                  l10n.disclaimerNotice,
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
              l10n.disclaimerCheckbox,
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
            color: colorScheme.surfaceContainer,
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
    AppLocalizations l10n,
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
                      _getLocalizedDocName(docKey, l10n),
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
