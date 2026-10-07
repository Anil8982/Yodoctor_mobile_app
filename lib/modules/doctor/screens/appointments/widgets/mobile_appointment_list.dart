import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/models/appointment/appointment_history_item.dart';

class MobileAppointmentList extends StatelessWidget {
  const MobileAppointmentList({
    super.key,
    required this.appointments,
    required this.onPrescriptionTap,
    required this.patientIdentityBuilder,
    required this.statusChipBuilder,
    required this.tokenChipBuilder,
    required this.infoChipBuilder,
  });

  final List<AppointmentHistoryItem> appointments;
  final ValueChanged<AppointmentHistoryItem> onPrescriptionTap;
  final Widget Function(AppointmentHistoryItem) patientIdentityBuilder;
  final Widget Function(String) statusChipBuilder;
  final Widget Function(String) tokenChipBuilder;
  final Widget Function(IconData, String) infoChipBuilder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: appointments.map((appointment) {
        final completed = appointment.status.toUpperCase() == 'COMPLETED';
        final canOpenPrescription =
            completed && !appointment.isWalkIn;
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.22)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: patientIdentityBuilder(appointment)),
                  statusChipBuilder(appointment.status),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        tokenChipBuilder(appointment.tokenNumber),
                        infoChipBuilder(Icons.medical_information, 'Consultation'),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  infoChipBuilder(
                    Icons.schedule_rounded,
                    DateFormat('dd MMM yyyy').format(appointment.date),
                  ),
                ],
              ),
              if (canOpenPrescription) ...[
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      onPrescriptionTap(appointment);
                    },
                    icon: Icon(
                      appointment.hasPrescription
                          ? Icons.receipt_long_rounded
                          : Icons.add_rounded,
                    ),
                    label: Text(
                      appointment.hasPrescription
                          ? 'View Prescription'
                          : 'Prescription',
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}