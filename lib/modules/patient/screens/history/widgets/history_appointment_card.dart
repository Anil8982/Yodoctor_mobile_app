import 'package:flutter/material.dart';
import 'package:yodoctor/core/theme/app_theme.dart';
import 'package:yodoctor/modules/widgets/status_chip.dart';
import '../../../models/history/appointment_history_model.dart';

class HistoryAppointmentCard extends StatelessWidget {
  const HistoryAppointmentCard({
    super.key,
    required this.appointment,
    required this.onViewDetails,
  });

  final AppointmentHistoryModel appointment;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 980;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isWide
          ? _buildWideLayout(context, textTheme, colorScheme)
          : _buildCompactLayout(context, textTheme, colorScheme),
    );
  }

  // WIDE LAYOUT (Desktop / Tablet)
  Widget _buildWideLayout(
      BuildContext context,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _buildDoctorInfo(context, textTheme, colorScheme),
        ),
        Expanded(
          flex: 3,
          child: _buildDateShiftInfo(context, textTheme, colorScheme),
        ),
        Expanded(
          flex: 2,
          child: _buildTokenChip(context, textTheme, colorScheme),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: StatusChip(status: appointment.status),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: _buildViewDetailsButton(context),
          ),
        ),
      ],
    );
  }

  // COMPACT LAYOUT (Mobile)
  Widget _buildCompactLayout(
      BuildContext context,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildDoctorInfo(context, textTheme, colorScheme),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: _buildDateShiftInfo(context, textTheme, colorScheme),
            ),
            const SizedBox(width: 10),
            _buildTokenChip(context, textTheme, colorScheme),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StatusChip(status: appointment.status),
            const SizedBox(width: 10),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: _buildViewDetailsButton(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoctorInfo(
      BuildContext context,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 24,
          backgroundColor: colorScheme.primaryContainer,
          backgroundImage:
          appointment.profileImage != null &&
              appointment.profileImage!.isNotEmpty
              ? NetworkImage(appointment.profileImage!)
              : null,
          child:
          appointment.profileImage == null ||
              appointment.profileImage!.isEmpty
              ? Icon(Icons.person_rounded, color: colorScheme.primary, size: 26)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                appointment.doctorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                appointment.specialization,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Patient: ${appointment.patientName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateShiftInfo(
      BuildContext context,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ) {
    final String slotText = appointment.appointmentSlot.trim();
    final String lowerSlot = slotText.toLowerCase();

    final bool isMorning = lowerSlot.contains('morn') || lowerSlot.contains('am');
    final bool isEvening = lowerSlot.contains('even') || lowerSlot.contains('pm') || lowerSlot.contains('night');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              appointment.appointmentDate,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        StatusChip(
          status: appointment.appointmentSlot,
          isSmall: true,
          customColor: isMorning
              ? AppTheme.warning(context)
              : (isEvening ? AppTheme.info(context) : colorScheme.primary),
          icon: isMorning
              ? Icons.wb_sunny_rounded
              : (isEvening ? Icons.nightlight_round : Icons.schedule_rounded),
        ),
      ],
    );
  }

  Widget _buildTokenChip(
      BuildContext context,
      TextTheme textTheme,
      ColorScheme colorScheme,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Token #${appointment.tokenNumber}',
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return OutlinedButton(
      onPressed: onViewDetails,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        visualDensity: VisualDensity.compact,
      ),
      child: const Text(
        'View Details',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}