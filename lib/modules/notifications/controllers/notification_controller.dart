import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/notification_model.dart';
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
  static const String _subTag = 'Notifier';

  @override
  NotificationState build() {
    AppLogger.info(
      'Initializing Notification Feed Pipeline...',
      tag: LogTags.notifications,
      subTag: _subTag,
    );
    Future.microtask(loadNotifications);
    return const NotificationState();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final repository = ref.read(notificationRepositoryProvider);

      List<NotificationModel> notifications = [];
      int unreadCount = state.unreadCount; // Preserve on count API fail
      String? errorMsg;

      // Fetch notifications list
      try {
        final notificationRes = await repository.getAllNotifications();
        if (notificationRes.statusCode == 200) {
          final rawList = notificationRes.data["notifications"] as List? ?? [];
          notifications =
              rawList.map((e) => NotificationModel.fromJson(e)).toList();
        } else {
          errorMsg = "Failed to fetch notifications";
        }
      } catch (e, st) {
        AppLogger.error(
          'Failed to fetch notifications list',
          tag: LogTags.notifications,
          subTag: _subTag,
          error: e,
          stackTrace: st,
        );
        errorMsg = "Failed to fetch notifications";
      }

      // Fetch unread count independently
      try {
        final unreadRes = await repository.getUnreadCount();
        if (unreadRes.statusCode == 200) {
          unreadCount = unreadRes.data["unreadCount"] ?? 0;
        }
      } catch (e, st) {
        AppLogger.error(
          'Failed to fetch unread count, preserving: $unreadCount',
          tag: LogTags.notifications,
          subTag: _subTag,
          error: e,
          stackTrace: st,
        );
      }

      AppLogger.success(
        'Feed synced. Count: ${notifications.length}, Unread: $unreadCount',
        tag: LogTags.notifications,
        subTag: _subTag,
      );

      state = state.copyWith(
        loading: false,
        notifications: notifications,
        unreadCount: unreadCount,
        errorMessage: errorMsg,
      );
    } catch (e, st) {
      AppLogger.error(
        'Notification sync crashed',
        tag: LogTags.notifications,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      state = state.copyWith(
        loading: false,
        errorMessage: "Connection error",
      );
    }
  }

  Future<bool> markAsRead(int id) async {
    AppLogger.info(
      'Marking ID: $id as read',
      tag: LogTags.notifications,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(notificationRepositoryProvider);
      final res = await repository.markAsRead(id);

      if (res.statusCode == 200 && res.data['success'] == true) {
        // Optimistic UI Update - only on confirmed success
        final updatedList = state.notifications.map((n) {
          return n.id == id ? n.copyWith(isRead: true) : n;
        }).toList();

        state = state.copyWith(
          notifications: updatedList,
          unreadCount: (state.unreadCount > 0) ? state.unreadCount - 1 : 0,
          clearError: true, // Clear any previous errors on success
        );

        AppLogger.success(
          'ID: $id marked read',
          tag: LogTags.notifications,
          subTag: _subTag,
        );
        return true;
      }

      AppLogger.info(
        'ID: $id already read or not found',
        tag: LogTags.notifications,
        subTag: _subTag,
      );
      return false;
    } catch (e, st) {
      AppLogger.error(
        'MarkAsRead failed for ID: $id',
        tag: LogTags.notifications,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    AppLogger.info(
      'Marking all notifications as read',
      tag: LogTags.notifications,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(notificationRepositoryProvider);
      final res = await repository.markAllAsRead();

      if (res.statusCode == 200 && res.data['success'] == true) {
        final updatedList =
        state.notifications.map((n) => n.copyWith(isRead: true)).toList();

        state = state.copyWith(
          notifications: updatedList,
          unreadCount: 0,
          clearError: true, // Clear any previous errors on success
        );

        AppLogger.success(
          'All marked read',
          tag: LogTags.notifications,
          subTag: _subTag,
        );
        return true;
      }
      return false;
    } catch (e, st) {
      AppLogger.error(
        'MarkAllAsRead failed',
        tag: LogTags.notifications,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }
}