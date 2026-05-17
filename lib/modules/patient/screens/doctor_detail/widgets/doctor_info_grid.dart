import 'package:flutter/material.dart';
import '../../../../../core/models/doctor_profile.dart';

class DoctorInfoGrid extends StatelessWidget {
  const DoctorInfoGrid({super.key, required this.doctor});

  final DoctorProfile doctor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double itemWidth = screenWidth > 560 ? (screenWidth - 76) / 2 : double.infinity;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _InfoTile(icon: Icons.local_hospital_rounded, label: 'Clinic Name', value: doctor.hospital, width: itemWidth),
        _InfoTile(icon: Icons.location_city_rounded, label: 'City', value: doctor.location, width: itemWidth),
        _InfoTile(icon: Icons.map_rounded, label: 'Address', value: 'Ashoka Garden', width: itemWidth),
        _InfoTile(icon: Icons.badge_rounded, label: 'License No', value: 'MPM123456', width: itemWidth),
        _InfoTile(icon: Icons.payments_rounded, label: 'Consultation Fee', value: '₹${doctor.consultationFee.toStringAsFixed(0)}', width: itemWidth),
        _InfoTile(icon: Icons.access_time_filled_rounded, label: 'Timings', value: doctor.availableSlot.isNotEmpty ? doctor.availableSlot : '15 mins', width: itemWidth),
        _InfoTile(icon: Icons.calendar_month_rounded, label: 'Available Days', value: 'Mon, Tue, Wed, Thu, Fri, Sat, Sun', width: double.infinity),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.width,
  });

  final IconData icon;
  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}