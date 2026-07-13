import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

import '../../../models/search/doctor_detail_model.dart';

class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({super.key, required this.doctor});

  final DoctorDetailModel doctor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.transparency(0.25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.primaryContainer.transparency(0.5),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colorScheme.primary,
            backgroundImage: doctor.profileImage.isNotEmpty
                ? NetworkImage(doctor.profileImage)
                : null,
            child: doctor.profileImage.isEmpty
                ? Text(
                    doctor.doctorName.replaceAll('Dr. ', '')[0],
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.doctorName,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.specialization,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
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
