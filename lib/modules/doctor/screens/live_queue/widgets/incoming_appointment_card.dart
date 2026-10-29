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

    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(appointment.appointmentDate);
    } catch (_) {
      parsedDate = DateTime.now();
    }
    final formattedDate = DateFormat("dd MMM yyyy").format(parsedDate);

    final slotText = appointment.appointmentSlot;
    final isMorning = slotText.toUpperCase().contains("MORNING");
    final formattedSlot = slotText.isNotEmpty
        ? slotText[0].toUpperCase() + slotText.substring(1).toLowerCase()
        : '';

    final successColor = AppTheme.success(context);
    final warningColor = AppTheme.warning(context);

    // Dynamic status color
    final statusColor = isAccepted
        ? successColor
        : isPending
        ? warningColor
        : colorScheme.outline;

    final cardBgColor = Color.alphaBlend(
      statusColor.withValues(alpha: 0.09), // soft tint
      colorScheme.surface,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.2), // gentle matching border
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Patient Profile, Name ani Token
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(context, statusColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName.isNotEmpty
                          ? appointment.patientName
                          : 'Walk-in Patient',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Appointment #${appointment.id}",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTokenBadge(context, statusColor),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // 2. Schedule Bar: Date ani Session Information
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "•",
                    style: TextStyle(
                      color: colorScheme.outlineVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  isMorning
                      ? Icons.wb_sunny_rounded
                      : Icons.nightlight_round_rounded,
                  size: 13,
                  color: isMorning ? warningColor : colorScheme.secondary,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "$formattedSlot Session",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // 3. Actions / Confirmed Indicator
          Row(
            children: [
              StatusChip(
                status: appointment.status,
                isSmall: true,
              ),
              const Spacer(),

              if (isAccepted)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: successColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Confirmed",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: successColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

              if (isPending) ...[
                TextButton(
                  onPressed: onReject,
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Decline",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                FilledButton(
                  onPressed: onAccept,
                  style: FilledButton.styleFrom(
                    backgroundColor: successColor,
                    foregroundColor: AppTheme.onSuccess(context),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Accept",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.onSuccess(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, Color statusColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasImage =
        appointment.profileImage != null && appointment.profileImage!.isNotEmpty;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surfaceContainerHigh,
        border: Border.all(
          color: statusColor.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: hasImage
            ? Image.network(
          appointment.profileImage!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackInitial(context),
        )
            : _buildFallbackInitial(context),
      ),
    );
  }

  Widget _buildFallbackInitial(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initial = appointment.patientName.isNotEmpty
        ? appointment.patientName[0].toUpperCase()
        : 'P';

    return Container(
      color: colorScheme.primary.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildTokenBadge(BuildContext context, Color statusColor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final token = appointment.tokenNumber.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        "#$token",
        style: theme.textTheme.labelMedium?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}