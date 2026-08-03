import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yodoctor/core/theme/app_theme.dart';

import '../../../../../core/utils/app_spacing.dart';
import '../../widgets/gradient_background.dart';

class AdminHeader extends ConsumerWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;
    final todayDate = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

    // final dashboardStateAsync = ref.watch(adminDashboardProvider);

    return GradientBackground(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      colors: AppTheme.adminGradient.colors,
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


          Text(
            'Admin Dashboard',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),
          Text(todayDate, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}