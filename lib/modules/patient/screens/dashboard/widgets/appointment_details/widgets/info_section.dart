import 'package:flutter/material.dart';
import 'package:yodoctor/modules/patient/models/dashboard/appointment_model.dart';
import 'section_header.dart';
import 'info_card.dart';

class InfoSection extends StatelessWidget {
  final AppointmentModel appointment;

  const InfoSection({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.event_rounded,
          title: 'Appointment Information',
        ),
        const SizedBox(height: 14),
        _AppointmentInfoGrid(appointment: appointment),
        const SizedBox(height: 24),
        const SectionHeader(
          icon: Icons.local_hospital_rounded,
          title: 'Clinic Information',
        ),
        const SizedBox(height: 14),
        _ClinicInfoGrid(appointment: appointment),
        const SizedBox(height: 14),
        InfoCard(
          icon: Icons.location_on_rounded,
          label: 'Clinic Address',
          value: appointment.address,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _AppointmentInfoGrid extends StatelessWidget {
  final AppointmentModel appointment;

  const _AppointmentInfoGrid({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        InfoCard(
          icon: Icons.person_rounded,
          label: 'Patient',
          value: appointment.familyName ?? "Self",
        ),
        InfoCard(
          icon: Icons.calendar_month_rounded,
          label: 'Date',
          value: appointment.appointmentDate,
        ),
        InfoCard(
          icon: Icons.access_time_filled_rounded,
          label: 'Time Slot',
          value: appointment.appointmentSlot,
        ),
        InfoCard(
          icon: Icons.confirmation_number_rounded,
          label: 'Token',
          value: '#${appointment.tokenNumber}',
        ),
      ],
    );
  }
}

class _ClinicInfoGrid extends StatelessWidget {
  final AppointmentModel appointment;

  const _ClinicInfoGrid({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        InfoCard(
          icon: Icons.local_hospital_rounded,
          label: 'Clinic',
          value: appointment.clinicName,
        ),
        InfoCard(
          icon: Icons.payments_rounded,
          label: 'Fee',
          value: '₹${appointment.consultationFee}',
        ),
        InfoCard(
          icon: Icons.location_city_rounded,
          label: 'City',
          value: appointment.city,
        ),
        InfoCard(
          icon: Icons.workspace_premium_rounded,
          label: 'Experience',
          value: '${appointment.experience} Yrs',
        ),
      ],
    );
  }
}