import 'package:flutter/material.dart';
import '../../../../../core/utils/app_spacing.dart';
import '../../../models/dashboard/appointment_model.dart';
import 'appointment_details/appointment_details_bottom_sheet.dart';
import 'appointment_details/widgets/doctor_profile_card.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Hero(
        tag: 'appointment-${appointment.id}',
        child: DoctorProfileCard(
          appointment: appointment,
          onTap: () {
            showAppointmentDetailsBottomSheet(context, appointment);
          },
          bottomContent: Row(
            children: <Widget>[
              Icon(
                Icons.person_outline_rounded,
                size: 15,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Patient: ${appointment.familyName ?? "Self"}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}