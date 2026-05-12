import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_spacing.dart';
import '../../../../../core/utils/dummy_data.dart';
import '../../../../../core/widgets/gradient_background.dart';

class PatientHeader extends StatelessWidget {
  const PatientHeader({super.key, required this.user});
  final PatientUser user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return GradientBackground(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        topPadding + 50,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          // Text(
          //   'Hello 👋',
          //   style: theme.textTheme.bodyLarge?.copyWith(
          //     color: colorScheme.onPrimary.transparency(0.85),
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          Text(
            user.name,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.transparency(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.onPrimary.transparency(0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: colorScheme.onPrimary,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  '4 upcoming visits',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary,
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
