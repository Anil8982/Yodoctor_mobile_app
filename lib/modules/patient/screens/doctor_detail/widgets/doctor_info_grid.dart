import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import '../../../models/search/doctor_detail_model.dart';

class DoctorInfoGrid extends StatelessWidget {
  const DoctorInfoGrid({super.key, required this.doctor});

  final DoctorDetailModel doctor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.transparency(.35),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _CompactItem(
                  icon: Icons.local_hospital_rounded,
                  label: "Clinic Name",
                  value: doctor.clinicName,
                ),
              ),
              Container(
                width: 1,
                height: 45,
                color: colorScheme.outlineVariant.transparency(.25),
              ),
              Expanded(
                child: _CompactItem(
                  icon: Icons.location_city_rounded,
                  label: "City",
                  value: doctor.city,
                ),
              ),
            ],
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.transparency(.25),
          ),

          Row(
            children: [
              Expanded(
                child: _CompactItem(
                  icon: Icons.map_rounded,
                  label: "Address",
                  value: doctor.address,
                ),
              ),
              Container(
                width: 1,
                height: 45,
                color: colorScheme.outlineVariant.transparency(.25),
              ),
              Expanded(
                child: _CompactItem(
                  icon: Icons.badge_rounded,
                  label: "License No",
                  value: doctor.licenseNumber,
                ),
              ),
            ],
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.transparency(.25),
          ),

          Row(
            children: [
              Expanded(
                child: _CompactItem(
                  icon: Icons.wb_sunny_rounded,
                  label: "Morning",
                  value: doctor.sessionTimings.morning.isEmpty
                      ? "Not Available"
                      : doctor.sessionTimings.morning,
                ),
              ),
              Container(
                width: 1,
                height: 45,
                color: colorScheme.outlineVariant.transparency(.25),
              ),
              Expanded(
                child: _CompactItem(
                  icon: Icons.nights_stay_rounded,
                  label: "Evening",
                  value: doctor.sessionTimings.evening.isEmpty
                      ? "Not Available"
                      : doctor.sessionTimings.evening,
                ),
              ),
            ],
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.transparency(.25),
          ),

          _CompactItem(
            icon: Icons.calendar_month_rounded,
            label: "Available Days",
            value: doctor.availableDays.isEmpty
                ? "Not Available"
                : doctor.availableDays.join(", "),
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _CompactItem extends StatelessWidget {
  const _CompactItem({
    required this.icon,
    required this.label,
    required this.value,
    this.isFullWidth = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.transparency(.5),
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: isFullWidth ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
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
