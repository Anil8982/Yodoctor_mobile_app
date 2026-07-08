import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/doctor/notification_model.dart';
import '../../../services/notification_service.dart';

class NotificationState {
  final bool loading;
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationState({
    this.loading = false,
    this.notifications = const [],
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    bool? loading,
    List<NotificationModel>? notifications,
    int? unreadCount,
  }) {
    return NotificationState(
      loading: loading ?? this.loading,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationNotifier extends Notifier<NotificationState> {
  final NotificationService _service = NotificationService();

  @override
  NotificationState build() {
    Future.microtask(loadNotifications);
    return const NotificationState();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(loading: true);

    try {
      final notificationRes = await _service.getNotifications();
      final unreadRes = await _service.unreadCount();

      final notifications = (notificationRes.data["notifications"] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();

      state = state.copyWith(
        loading: false,
        notifications: notifications,
        unreadCount: unreadRes.data["unreadCount"] ?? 0,
      );
    } catch (e) {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> markAllAsRead() async {
    await _service.markAllRead();
    await loadNotifications();
  }

  Future<void> markAsRead(int id) async {
    await _service.markRead(id);
    await loadNotifications();
  }
}

final notificationProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(
      NotificationNotifier.new,
    );
