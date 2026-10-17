import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/network/dio_provider.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.read(dioProvider));
});

class NotificationRepository {
  NotificationRepository(this._dio);
  final Dio _dio;

  /// 1. Get All Notifications
  Future<Response> getAllNotifications() {
    return _dio.get(ApiConstants.getNotifications);
  }

  /// 2. Get Unread Notification Count
  Future<Response> getUnreadCount() {
    return _dio.get(ApiConstants.unreadCount);
  }

  /// 3. Mark One Notification as Read
  /// URL: /notifications/:id/read
  Future<Response> markAsRead(int notificationId) {
    return _dio.put('${ApiConstants.readNotification}$notificationId/read');
  }

  /// 4. Mark All Notifications as Read
  Future<Response> markAllAsRead() {
    return _dio.put(ApiConstants.readAllNotifications);
  }
}