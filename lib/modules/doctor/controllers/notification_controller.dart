import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../core/models/doctor/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationState {
  final bool loading;
  final List<NotificationModel> notifications;
  final int unreadCount;
  final String? errorMessage;

  const NotificationState({
    this.loading = false,
    this.notifications = const [],
    this.unreadCount = 0,
    this.errorMessage,
  });

  NotificationState copyWith({
    bool? loading,
    List<NotificationModel>? notifications,
    int? unreadCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      loading: loading ?? this.loading,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final notificationProvider =
NotifierProvider<NotificationNotifier, NotificationState>(
  NotificationNotifier.new,
);

class NotificationNotifier extends Notifier<NotificationState> {
  static const String _subTag = 'NotificationNotifier';

  @override
  NotificationState build() {
    AppLogger.info('NotificationNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);
    Future.microtask(loadNotifications);
    return const NotificationState();
  }

  Future<void> loadNotifications() async {
    if (state.loading) return;
    state = state.copyWith(loading: true, clearError: true);
    AppLogger.info('Initializing notification feed synchronization pipeline...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(notificationRepositoryProvider);

      final results = await Future.wait([
        repository.getNotifications(),
        repository.unreadCount(),
      ]);

      final notificationRes = results[0];
      final unreadRes = results[1];

      final nStatus = notificationRes.statusCode ?? 0;
      final uStatus = unreadRes.statusCode ?? 0;

      if (nStatus >= 200 && nStatus < 300 && uStatus >= 200 && uStatus < 300) {
        final rawList = notificationRes.data["notifications"] as List? ?? [];
        final notifications = rawList.map((e) => NotificationModel.fromJson(e)).toList();
        final unreadCount = unreadRes.data["unreadCount"] ?? 0;

        AppLogger.success('Notifications feed aggregated seamlessly. Count: ${notifications.length}, Unread: $unreadCount', tag: LogTags.doctor, subTag: _subTag);
        AppLogger.json({
          "notifications_count": notifications.length,
          "unread_count": unreadCount,
        }, tag: LogTags.doctor, subTag: '$_subTag/NotificationSyncData');

        state = state.copyWith(
          loading: false,
          notifications: notifications,
          unreadCount: unreadCount,
        );
      } else {
        AppLogger.warning('Failed to aggregate alerts. NotificationStatus: $nStatus, UnreadStatus: $uStatus', tag: LogTags.doctor, subTag: _subTag);
        state = state.copyWith(loading: false, errorMessage: "Failed to load fresh alerts");
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to connect with notification center");
      AppLogger.exception(e, st, message: 'Notification workspace stream exception crash', tag: LogTags.doctor, subTag: _subTag);
    }
  }

  Future<bool> markAllAsRead() async {
    AppLogger.info('Requesting to mark all notifications as read...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(notificationRepositoryProvider);
      final res = await repository.markAllRead();
      final statusCode = res.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        AppLogger.success('All notifications marked as read on server successfully', tag: LogTags.doctor, subTag: _subTag);
        await loadNotifications();
        return true;
      }
      AppLogger.warning('Failed to mark all as read. Status: $statusCode', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Mark all as read execution failure', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }

  Future<bool> markAsRead(int id) async {
    AppLogger.info('Marking individual notification ID: $id as read...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(notificationRepositoryProvider);
      final res = await repository.markRead(id);
      final statusCode = res.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        AppLogger.success('Notification ID: $id marked as read successfully', tag: LogTags.doctor, subTag: _subTag);
        await loadNotifications();
        return true;
      }
      AppLogger.warning('Failed to mark notification ID: $id as read. Status: $statusCode', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Mark individual notification read crash', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }
}