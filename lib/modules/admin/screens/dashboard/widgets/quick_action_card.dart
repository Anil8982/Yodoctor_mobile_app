import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/admin/controllers/admin_dashboard_controller.dart';

class QuickActionsWidget extends ConsumerWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final dashboardStateAsync = ref.watch(adminDashboardProvider);

    return dashboardStateAsync.maybeWhen(
      data: (state) {
        final data = state.rawData;
        if (data == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QUICK ACTIONS',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            isMobile
                ? Column(
              children: [
                _buildCard(
                  context,
                  icon: Icons.pending_actions_outlined,
                  iconColor: Colors.orange,
                  title: 'Pending Approvals',
                  subtitle: 'Doctors waiting for verification',
                  count: data.pendingApprovals.toString(),
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  icon: Icons.people_outline,
                  iconColor: Colors.blue,
                  title: 'All Doctors',
                  subtitle: 'View and manage registered doctors',
                  count: data.totalDoctors.toString(),
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  icon: Icons.notifications_none,
                  iconColor: Colors.purple,
                  title: 'Notifications',
                  subtitle: 'View all admin notifications',
                  count: '0',
                  onTap: () {},
                ),
              ],
            )
                : Row(
              children: [
                Expanded(
                  child: _buildCard(
                    context,
                    icon: Icons.pending_actions_outlined,
                    iconColor: Colors.orange,
                    title: 'Pending Approvals',
                    subtitle: 'Doctors waiting for verification',
                    count: data.pendingApprovals.toString(),
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    context,
                    icon: Icons.people_outline,
                    iconColor: Colors.blue,
                    title: 'All Doctors',
                    subtitle: 'View and manage registered doctors',
                    count: data.totalDoctors.toString(),
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    context,
                    icon: Icons.notifications_none,
                    iconColor: Colors.purple,
                    title: 'Notifications',
                    subtitle: 'View all admin notifications',
                    count: '0',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(
      BuildContext context, {
        required IconData icon,
        required Color iconColor,
        required String title,
        required String subtitle,
        required String count,
        required VoidCallback onTap,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.transparency(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: iconColor.transparency(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    count,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}