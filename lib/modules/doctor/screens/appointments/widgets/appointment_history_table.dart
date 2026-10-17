import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/doctor/models/appointment/appointment_history_item.dart';

class AppointmentHistoryTable extends StatelessWidget {
  const AppointmentHistoryTable({
    super.key,
    required this.appointments,
    required this.onPrescriptionTap,
    required this.patientNameParser,
    required this.patientIdentityBuilder,
    required this.tokenChipBuilder,
    required this.statusChipBuilder,
  });

  final List<AppointmentHistoryItem> appointments;
  final ValueChanged<AppointmentHistoryItem> onPrescriptionTap;
  final String Function(String) patientNameParser;
  final Widget Function(AppointmentHistoryItem) patientIdentityBuilder;
  final Widget Function(String) tokenChipBuilder;
  final Widget Function(String) statusChipBuilder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 56,
          dataRowMinHeight: 76,
          dataRowMaxHeight: 76,
          horizontalMargin: AppSpacing.lg,
          columnSpacing: 54,
          headingTextStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
          columns: const [
            DataColumn(label: Text('PATIENT')),
            DataColumn(label: Text('TYPE')),
            DataColumn(label: Text('TOKEN')),
            DataColumn(label: Text('DATE & TIME')),
            DataColumn(label: Text('STATUS')),
            DataColumn(label: Text('ACTION')),
          ],
          rows: appointments.map((appointment) {
            final completed =
                appointment.status.toUpperCase() == 'COMPLETED';

            final canOpenPrescription =
                completed && !appointment.isWalkIn;

            return DataRow(
              cells: [
                DataCell(patientIdentityBuilder(appointment)),
                const DataCell(Text('Consultation')),
                DataCell(tokenChipBuilder(appointment.tokenNumber)),
                DataCell(
                  Text(
                    DateFormat(
                      'dd MMM yyyy, hh:mm a',
                    ).format(appointment.date),
                  ),
                ),
                DataCell(statusChipBuilder(appointment.status)),
                DataCell(
                  canOpenPrescription
                      ? FilledButton.icon(
                    onPressed: () =>
                        onPrescriptionTap(appointment),
                    icon: Icon(
                      appointment.hasPrescription
                          ? Icons.receipt_long_rounded
                          : Icons.add_rounded,
                      size: 17,
                    ),
                    label: Text(
                      appointment.hasPrescription
                          ? 'View Prescription'
                          : 'Prescription',
                    ),
                  )
                      : const SizedBox(width: 120),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
