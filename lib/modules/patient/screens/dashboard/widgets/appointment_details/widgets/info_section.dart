import 'package:flutter/material.dart';
import 'package:yodoctor/l10n/app_localizations.dart';
import 'package:yodoctor/modules/patient/models/dashboard/appointment_model.dart';
import 'section_header.dart';
import 'info_card.dart';

class InfoSection extends StatelessWidget {
  final AppointmentModel appointment;

  const InfoSection({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: Icons.event_rounded,
          title: l10n.appointmentInformation,
        ),
        const SizedBox(height: 14),
        _AppointmentInfoGrid(appointment: appointment, l10n: l10n),
        const SizedBox(height: 24),
        SectionHeader(
          icon: Icons.local_hospital_rounded,
          title: l10n.clinicInformation,
        ),
        const SizedBox(height: 14),
        _ClinicInfoGrid(appointment: appointment, l10n: l10n),
        const SizedBox(height: 14),
        InfoCard(
          icon: Icons.location_on_rounded,
          label: l10n.clinicAddress,
          value: appointment.address,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _AppointmentInfoGrid extends StatelessWidget {
  final AppointmentModel appointment;
  final AppLocalizations l10n;

  const _AppointmentInfoGrid({
    required this.appointment,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        InfoCard(
          icon: Icons.person_rounded,
          label: l10n.patientInfoLabel,
          value: appointment.familyName ?? l10n.patientSelf,
        ),
        InfoCard(
          icon: Icons.calendar_month_rounded,
          label: l10n.dateLabel,
          value: appointment.appointmentDate,
        ),
        InfoCard(
          icon: Icons.access_time_filled_rounded,
          label: l10n.timeSlotLabel,
          value: appointment.appointmentSlot,
        ),
        InfoCard(
          icon: Icons.confirmation_number_rounded,
          label: l10n.tokenNumberLabel,
          value: '#${appointment.tokenNumber}',
        ),
      ],
    );
  }
}

class _ClinicInfoGrid extends StatelessWidget {
  final AppointmentModel appointment;
  final AppLocalizations l10n;

  const _ClinicInfoGrid({
    required this.appointment,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        InfoCard(
          icon: Icons.local_hospital_rounded,
          label: l10n.clinicLabel,
          value: appointment.clinicName,
        ),
        InfoCard(
          icon: Icons.payments_rounded,
          label: l10n.feeLabel,
          value: '₹${appointment.consultationFee}',
        ),
        InfoCard(
          icon: Icons.location_city_rounded,
          label: l10n.cityLabel,
          value: appointment.city,
        ),
        InfoCard(
          icon: Icons.workspace_premium_rounded,
          label: l10n.experienceLabel,
          value: l10n.experienceYears(appointment.experience.toString()),
        ),
      ],
    );
  }
}
