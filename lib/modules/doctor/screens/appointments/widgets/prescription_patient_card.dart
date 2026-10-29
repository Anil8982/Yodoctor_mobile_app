import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/models/appointment/prescription_model.dart';

class PrescriptionPatientCard extends StatelessWidget {
  final String appointmentId;
  final String patientName;
  final String tokenNumber;
  final PrescriptionPatient? patient;

  const PrescriptionPatientCard({
    super.key,
    required this.appointmentId,
    required this.patientName,
    required this.tokenNumber,
    this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final patientAgeGender = [
      if (patient?.age != null && patient!.age! > 0) "${patient!.age} Yrs",
      if (patient?.gender != null && patient!.gender!.isNotEmpty)
        patient!.gender!,
    ].join(' • ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.transparency(0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.person_rounded,
              color: colorScheme.onPrimaryContainer,
              size: 26,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient?.name.isNotEmpty == true ? patient!.name : patientName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      "ID: $appointmentId",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (patientAgeGender.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text("•", style: TextStyle(color: colorScheme.outline)),
                      const SizedBox(width: 8),
                      Text(
                        patientAgeGender,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.transparency(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.transparency(0.2),
              ),
            ),
            child: Text(
              tokenNumber.startsWith('#')
                  ? "Token $tokenNumber"
                  : "Token #$tokenNumber",
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}