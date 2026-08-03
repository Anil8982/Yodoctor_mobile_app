import 'package:flutter/material.dart';

import '../../../../../core/utils/app_spacing.dart';
import '../../../../widgets/app_button.dart';

class DoctorActionButtons extends StatelessWidget {
  const DoctorActionButtons({
    super.key,
    required this.onProfileTap,
    required this.onBookTap,
    required this.onContactTap,
  });

  final VoidCallback onProfileTap;
  final VoidCallback onBookTap;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: AppButton(
            label: 'Book Appointment',
            onPressed: onBookTap,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppButton(
            label: 'Contact Doctor',
            onPressed: onContactTap,
            variant: AppButtonVariant.outlined,
            foregroundColor: colorScheme.primary,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ],
    );
  }
}
