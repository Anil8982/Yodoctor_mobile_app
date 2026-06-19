import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/notification_item.dart';
import '../../../../core/utils/dummy_data.dart';

class NotificationState {
  final List<NotificationItem> notifications;

  const NotificationState({required this.notifications});

  NotificationState copyWith({List<NotificationItem>? notifications}) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
    );
  }
}

class NotificationNotifier extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    return NotificationState(notifications: List.from(DummyData.dummyNotifications));
  }

  void markAllAsRead() {
    state = state.copyWith(
      notifications: state.notifications.map((n) => n.copyWith(isRead: true)).toList(),
    );
  }

  void markAsRead(String id) {
    state = state.copyWith(
      notifications: state.notifications.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList(),
    );
  }
}

final notificationProvider = NotifierProvider<NotificationNotifier, NotificationState>(
  NotificationNotifier.new,
);