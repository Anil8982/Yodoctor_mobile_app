import 'package:flutter/material.dart';
import '../../../../../../core/utils/app_spacing.dart';

class DoctorsManagementHeader extends StatelessWidget {
  const DoctorsManagementHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        topPadding + 50,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            'Doctors Management',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),
          Text( 'Review and manage doctor registrations', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
