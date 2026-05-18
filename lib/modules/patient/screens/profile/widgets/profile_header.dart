import 'package:flutter/material.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';

class ProfileHeader extends StatelessWidget {
  final PatientUser user;
  final bool isEditing;

  const ProfileHeader({super.key, required this.user, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1), width: 6),
              ),
              child: CircleAvatar(
                radius: 65,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  user.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900, color: colorScheme.onPrimaryContainer),
                ),
              ),
            ),
            if (isEditing)
              CircleAvatar(
                backgroundColor: colorScheme.primary,
                radius: 22,
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: colorScheme.onPrimary,
                  size: 22,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(user.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'PATIENT ID: ${user.id}',
            style: TextStyle(color: colorScheme.onSecondaryContainer, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
        ),
      ],
    );
  }
}
