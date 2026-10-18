import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/controllers/certificate_request.dart';
import 'package:yodoctor/modules/widgets/app_dropdown_field.dart';
import 'package:yodoctor/modules/widgets/app_text_field.dart';
import 'certificate_type_card.dart';
import 'step_header_helper.dart';

class Step1TypeSelection extends ConsumerWidget {
  final GlobalKey formKey;
  final CertificateNotifier controller;
  final AutovalidateMode? autovalidateMode;

  const Step1TypeSelection({
    super.key,
    required this.formKey,
    required this.controller,
    this.autovalidateMode,
  });

  static const List<Map<String, dynamic>> _certificateTypes = [
    {
      'title': 'Medical Fitness',
      'icon': Icons.fitness_center_rounded,
    },
    {
      'title': 'Vaccination',
      'icon': Icons.vaccines_rounded,
    },
    {
      'title': 'Disability',
      'icon': Icons.accessible_rounded,
    },
    {
      'title': 'Second Opinion',
      'icon': Icons.rate_review_rounded,
    },
    {
      'title': 'Discharge Summary',
      'icon': Icons.article_rounded,
    },
  ];

  String _getLocalizedTitle(String key, AppLocalizations l10n) {
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

  String _getLocalizedDesc(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Medical Fitness':
        return l10n.certMedicalFitnessDesc;
      case 'Vaccination':
        return l10n.certVaccinationDesc;
      case 'Disability':
        return l10n.certDisabilityDesc;
      case 'Second Opinion':
        return l10n.certSecondOpinionDesc;
      case 'Discharge Summary':
        return l10n.certDischargeSummaryDesc;
      default:
        return '';
    }
  }

  String _getLocalizedPurpose(String purpose, AppLocalizations l10n) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current form state reactively from provider
    final formState = ref.watch(certificateProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: l10n.selectCertificateType,
            desc: l10n.selectCertificateTypeDesc,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemCount: _certificateTypes.length,
            itemBuilder: (context, idx) {
              final type = _certificateTypes[idx];
              final titleKey = type['title'] as String;
              return CertificateTypeCard(
                title: _getLocalizedTitle(titleKey, l10n),
                description: _getLocalizedDesc(titleKey, l10n),
                icon: type['icon'],
                isSelected: formState.selectedType == titleKey,
                onTap: () => controller.setSelectedType(titleKey),
              );
            },
          ),
          const SizedBox(height: 28),

          if (formState.assignedDoctor != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(Icons.person_rounded, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.assignedDoctor,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formState.assignedDoctor!.name} (${formState.assignedDoctor!.specialty})',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ],
              ),
            )
          else
            const SizedBox.shrink(),
          const SizedBox(height: 20),

          // Purpose of Certificate Dropdown
          AppDropdownField<String>(
            label: l10n.purposeOfCertificate,
            isRequired: true,
            hint: l10n.selectPurpose,
            icon: Icons.assignment_turned_in_rounded,
            value: formState.purpose,
            items: const [
              'Travel',
              'Employment',
              'Sports',
              'School/University',
              'Insurance',
              'Other',
            ],
            itemLabelBuilder: (item) => _getLocalizedPurpose(item, l10n),
            autovalidateMode: autovalidateMode,
            onChanged: (value) {
              if (value != null) {
                controller.setPurpose(value);
              }
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseSelectPurpose;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Additional Notes Field
          AppTextField(
            controller: controller.additionalNotesController,
            autovalidateMode: autovalidateMode,
            label: l10n.additionalNotesForDoctor,
            hint: l10n.additionalNotesHint,
            icon: Icons.note_alt_outlined,
            maxLines: 3,
            minLines: 1,
            maxLength: 2000,
          ),
        ],
      ),
    );
  }
}
