import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/status_chip.dart';

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
        ? slotText.substring(0, 1).toUpperCase() +
        slotText.substring(1).toLowerCase()
        : '';

    final successColor = AppTheme.success(context);
    final warningColor = AppTheme.warning(context);
    final infoColor = AppTheme.info(context);

    final borderColor = isAccepted
        ? successColor.withValues(alpha: 0.4)
        : colorScheme.outlineVariant.withValues(alpha: 0.4);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              width: 170,
              height: 150,
              child: ClipPath(
                clipper: RightCurveClipper(),
                child: Container(
                  color: isAccepted
                      ? successColor.withValues(alpha: 0.12)
                      : isPending
                      ? warningColor.withValues(alpha: 0.12)
                      : infoColor.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              right: 18,
              bottom: 8,
              child: Icon(
                isAccepted
                    ? Icons.check_circle_outline_rounded
                    : Icons.access_time_rounded,
                size: 32,
                color: isAccepted
                    ? successColor.withValues(alpha: 0.25)
                    : isPending
                    ? warningColor.withValues(alpha: 0.25)
                    : infoColor.withValues(alpha: 0.25),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
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
                            color: isAccepted
                                ? successColor.withValues(alpha: 0.4)
                                : colorScheme.primary.withValues(alpha: 0.25),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: isAccepted
                              ? successColor.withValues(alpha: 0.15)
                              : colorScheme.primaryContainer,
                          backgroundImage:
                          appointment.profileImage != null &&
                              appointment.profileImage!.isNotEmpty
                              ? NetworkImage(appointment.profileImage!)
                              : null,
                          child:
                          appointment.profileImage == null ||
                              appointment.profileImage!.isEmpty
                              ? Text(
                            appointment.patientName.isNotEmpty
                                ? appointment.patientName[0].toUpperCase()
                                : 'P',
                            style: TextStyle(
                              color: isAccepted
                                  ? successColor
                                  : colorScheme.onPrimaryContainer,
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
                                      ? warningColor
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
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
                              ? successColor.withValues(alpha: 0.15)
                              : colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "#${appointment.tokenNumber.toString().padLeft(2, '0')}",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isAccepted
                                ? successColor
                                : colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Divider(
                    color: isAccepted
                        ? successColor.withValues(alpha: 0.2)
                        : colorScheme.outlineVariant.withValues(alpha: 0.3),
                    thickness: 1,
                    endIndent: 22,
                  ),

                  const SizedBox(height: 8),

                  // Bottom Actions / Status
                  if (isAccepted)
                    Padding(
                      padding: const EdgeInsets.only(right: 45),
                      child: Row(
                        children: [
                          StatusChip(
                            status: appointment.status,
                            isSmall: true,
                          ),
                          const Spacer(),
                          Text(
                            "Appointment Confirmed",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (isPending)
                    Padding(
                      padding: const EdgeInsets.only(right: 55),
                      child: Row(
                        children: [
                          StatusChip(
                            status: appointment.status,
                            isSmall: true,
                          ),

                          const Spacer(),

                          OutlinedButton.icon(
                            onPressed: onReject,
                            icon: const Icon(Icons.close_rounded, size: 15),
                            label: const Text("Reject"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(
                                color: colorScheme.error.withValues(alpha: 0.4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(width: 6),

                          FilledButton.icon(
                            onPressed: onAccept,
                            icon: const Icon(Icons.check_rounded, size: 15),
                            label: const Text("Accept"),
                            style: FilledButton.styleFrom(
                              backgroundColor: successColor,
                              foregroundColor: AppTheme.onSuccess(context),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RightCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    path.lineTo(size.width * 0.28, size.height);

    path.cubicTo(
      size.width * 0.72,
      size.height * 0.92,
      size.width * 0.95,
      size.height * 0.42,
      size.width,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
