import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import '../../controllers/notification_controller.dart';
import 'widgets/notification_card.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);

    final todayNotifications = state.notifications
        .where((n) => n.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 1))))
        .toList();

    final olderNotifications = state.notifications
        .where((n) => n.createdAt.isBefore(DateTime.now().subtract(const Duration(days: 1))))
        .toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Notifications",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimary,
              ),
            ),
            if (state.unreadCount > 0)
              Text(
                "${state.unreadCount} unread",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.85),
                ),
              ),
          ],
        ),
        centerTitle: false,
        backgroundColor: colorScheme.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        actions: [
          IconButton(
            icon: Icon(Icons.done_all_rounded, color: colorScheme.onPrimary),
            // 🎯 FIXED: Disable action button during active loading states to prevent multiple network fires
            onPressed: state.unreadCount == 0 || state.loading
                ? null
                : () async {
              await notifier.markAllAsRead();
            },
          ),
        ],
      ),
      // 🎯 FIXED LOADING BUG: Show progress indicator cleanly instead of flashing "All caught up!" on initialization
      body: state.loading && state.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            // 🎯 FIXED UX: Non-blocking top indicator if background refresh/mutation pipeline runs
            if (state.loading && state.notifications.isNotEmpty)
              LinearProgressIndicator(
                color: colorScheme.primary,
                backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.2),
              ),

            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: state.notifications.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 64,
                          color: colorScheme.onSurfaceVariant.transparency(0.4),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          "All caught up!",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          state.errorMessage ?? "You don't have any notifications right now.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      if (todayNotifications.isNotEmpty) ...[
                        Text(
                          "Today",
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...todayNotifications.map(
                              (n) => NotificationCard(
                            notification: n,
                            onTap: () async {
                              await notifier.markAsRead(n.id);
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (olderNotifications.isNotEmpty) ...[
                        Text(
                          "Older",
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...olderNotifications.map(
                              (n) => NotificationCard(
                            notification: n,
                            onTap: () async {
                              await notifier.markAsRead(n.id);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}