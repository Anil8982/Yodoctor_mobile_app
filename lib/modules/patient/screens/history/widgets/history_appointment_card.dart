import 'package:flutter/material.dart';
import '../../../models/history/appointment_history_model.dart';

class HistoryAppointmentCard extends StatelessWidget {
  const HistoryAppointmentCard({
    super.key,
    required this.appointment,
    required this.onViewDetails,
  });

  final AppointmentHistoryModel appointment;
  final VoidCallback onViewDetails;

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

  Widget _buildWideLayout(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Row(
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
          child: _buildStatusChip(context, textTheme, colorScheme),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.center,
            child: _buildViewDetailsButton(context),
          ),
        ),
      ],
    );
  }

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
          children: <Widget>[
            Expanded(
              child: _buildDateShiftInfo(context, textTheme, colorScheme),
            ),
            const SizedBox(width: 10),
            Expanded(child: _buildTokenChip(context, textTheme, colorScheme)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(child: _buildStatusChip(context, textTheme, colorScheme)),
            const SizedBox(width: 10),
            Expanded(child: _buildViewDetailsButton(context)),
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
          radius: 22,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(Icons.person_rounded, color: colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                appointment.doctorName,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                appointment.specialization,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Patient: ${appointment.patientName}',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              appointment.appointmentDate,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.wb_twilight_rounded,
                size: 14,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                appointment.appointmentSlot,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTokenChip(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          appointment.tokenNumber.toString(),
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 22,
              backgroundImage: appointment.profileImage != null
                  ? NetworkImage(appointment.profileImage!)
                  : null,
              child: appointment.profileImage == null
                  ? Icon(Icons.person_rounded, color: colorScheme.primary)
                  : null,
            ),
          ],
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
      ),
      child: const Text(
        'View Details',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
