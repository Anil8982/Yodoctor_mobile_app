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

  Future<Response> getNotifications({int page = 1}) {
    return _dio.get(
      ApiConstants.notifications,
      queryParameters: {"page": page},
    );
  }

  Future<Response> unreadCount() {
    return _dio.get(ApiConstants.unreadNotifications);
  }

  Future<Response> markRead(int id) {
    return _dio.put('${ApiConstants.notifications}/$id/read');
  }

  Future<Response> markAllRead() {
    return _dio.put(ApiConstants.readAllNotifications);
  }
}