import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';

import '../../../../patient/models/appointment/incoming_appointment_model.dart';

class IncomingAppointmentCard extends StatelessWidget {
  final IncomingAppointmentModel appointment;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const IncomingAppointmentCard({
    super.key,
    required this.appointment,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final status = appointment.status.toUpperCase();
    final isPending = status == "PENDING";
    final isAccepted = status == "ACCEPTED";

    final date = DateFormat(
      "dd MMM yyyy",
    ).format(DateTime.parse(appointment.appointmentDate));

    final slotText = appointment.appointmentSlot;
    final isMorning = slotText.toUpperCase().contains("MORNING");

    final formattedSlot = slotText.isNotEmpty
        ? slotText.substring(0, 1).toUpperCase() + slotText.substring(1).toLowerCase()
        : '';

    // Accepted asel tar card la green tint/border, pending asel tar orange/normal
    final cardBgColor = isAccepted
        ? Colors.green.shade50.withValues(alpha: 0.5)
        : colorScheme.surface;

    final borderColor = isAccepted
        ? Colors.green.shade300
        : colorScheme.outlineVariant.withValues(alpha: 0.4);

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: isAccepted ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar, Info & Token
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Avatar
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isAccepted ? Colors.green.shade300 : colorScheme.primary.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: isAccepted ? Colors.green.shade100 : colorScheme.primaryContainer,
                    backgroundImage: appointment.profileImage != null &&
                        appointment.profileImage!.isNotEmpty
                        ? NetworkImage(appointment.profileImage!)
                        : null,
                    child: appointment.profileImage == null ||
                        appointment.profileImage!.isEmpty
                        ? Text(
                      appointment.patientName.isNotEmpty
                          ? appointment.patientName[0].toUpperCase()
                          : 'P',
                      style: TextStyle(
                        color: isAccepted ? Colors.green.shade800 : colorScheme.onPrimaryContainer,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : null,
                  ),
                ),

                const SizedBox(width: 12),

                // Name & Slot/Date Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          Icon(
                            isMorning
                                ? Icons.wb_sunny_rounded
                                : Icons.nightlight_round_outlined,
                            color: isMorning
                                ? Colors.amber.shade700
                                : colorScheme.secondary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedSlot,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "|",
                              style: TextStyle(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            date,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Token Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isAccepted
                        ? Colors.green.shade100
                        : colorScheme.primaryContainer.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "#${appointment.tokenNumber.toString().padLeft(2, '0')}",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isAccepted ? Colors.green.shade800 : colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Divider(
              color: isAccepted ? Colors.green.shade200 : colorScheme.outlineVariant.withValues(alpha: 0.3),
              thickness: 1,
            ),

            const SizedBox(height: 8),

            // Bottom Actions / Status
            if (isAccepted)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircleAvatar(
                          radius: 3.5,
                          backgroundColor: Colors.green,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "ACCEPTED",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Appointment Confirmed",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

            if (isPending)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.orange.shade200.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircleAvatar(
                          radius: 3.5,
                          backgroundColor: Colors.orange,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "PENDING",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: onReject,
                        icon: const Icon(Icons.close_rounded, size: 16),
                        label: const Text("Reject"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          side: BorderSide(
                            color: colorScheme.error.withValues(alpha: 0.4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: onAccept,
                        icon: const Icon(Icons.check_rounded, size: 16),
                        label: const Text("Accept"),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xff1BCB7F),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}