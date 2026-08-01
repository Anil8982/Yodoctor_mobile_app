import 'package:chroma_kit/chroma_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/utils/app_spacing.dart';
import 'package:yodoctor/modules/widgets/app_header.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);

    // Proper "Today" calculation using calendar day boundary
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    final todayNotifications = state.notifications
        .where((n) => !n.createdAt.toLocal().isBefore(startOfToday))
        .toList();

    final olderNotifications = state.notifications
        .where((n) => n.createdAt.toLocal().isBefore(startOfToday))
        .toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        title: 'Notification',
        subtitle: state.unreadCount > 0 ? "${state.unreadCount} unread" : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            onPressed: state.unreadCount == 0 || state.loading
                ? null
                : () async {
                    await notifier.markAllAsRead();
                  },
          ),
        ],
      ),
      body: state.loading && state.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () => notifier.loadNotifications(),
                color: colorScheme.primary,
                backgroundColor: colorScheme.surface,
                child: Column(
                  children: [
                    if (state.loading && state.notifications.isNotEmpty)
                      LinearProgressIndicator(
                        color: colorScheme.primary,
                        backgroundColor: colorScheme.primaryContainer
                            .withValues(alpha: 0.2),
                      ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
                          child: state.notifications.isEmpty
                              ? ListView(
                                  // ListView needed for RefreshIndicator to work on empty state
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.6,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.notifications_none_rounded,
                                              size: 64,
                                              color: colorScheme
                                                  .onSurfaceVariant
                                                  .transparency(0.4),
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.md,
                                            ),
                                            Text(
                                              "All caught up!",
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            Text(
                                              state.errorMessage ??
                                                  "You don't have any notifications right now.",
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(AppSpacing.lg),
                                  children: [
                                    if (todayNotifications.isNotEmpty) ...[
                                      Text(
                                        "Today",
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
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
                                            if (!n.isRead) {
                                              await notifier.markAsRead(n.id);
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.lg),
                                    ],
                                    if (olderNotifications.isNotEmpty) ...[
                                      Text(
                                        "Older",
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
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
                                            if (!n.isRead) {
                                              await notifier.markAsRead(n.id);
                                            }
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
            ),
    );
  }
}
