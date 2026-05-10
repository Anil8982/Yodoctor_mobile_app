import 'package:flutter/material.dart';

import '../../../../../core/utils/app_spacing.dart';
import '../../../../../core/utils/dummy_data.dart';
import '../../../../../core/widgets/app_button.dart';
import 'doctor_action_buttons.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    this.onProfileTap,
    this.onBookTap,
    this.onContactTap,
  });

  final DoctorProfile doctor;
  final VoidCallback? onProfileTap;
  final VoidCallback? onBookTap;
  final VoidCallback? onContactTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      doctor.name.split(' ').last.substring(0, 1),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        doctor.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        doctor.specialty,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Consultation: ₹${doctor.consultationFee}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        children: <Widget>[
                          _MetaItem(icon: Icons.local_hospital_outlined, text: doctor.hospital),
                          _MetaItem(icon: Icons.location_on_outlined, text: doctor.location),
                          _MetaItem(icon: Icons.work_outline_rounded, text: '${doctor.experienceYears} yrs'),
                          _MetaItem(
                            icon: Icons.star_rounded,
                            text: doctor.rating.toString(),
                            iconColor: Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Profile',
              onPressed: onProfileTap ?? () {},
              variant: AppButtonVariant.outlined,
              foregroundColor: colorScheme.onSurface,
              backgroundColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            const SizedBox(height: AppSpacing.md),
            DoctorActionButtons(
              onProfileTap: onProfileTap ?? () {},
              onBookTap: onBookTap ?? () {},
              onContactTap: onContactTap ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.text, this.iconColor});

  final IconData icon;
  final String text;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: iconColor ?? colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
