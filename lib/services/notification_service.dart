import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class NotificationService {
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  Future<Response> getNotifications({int page = 1}) async {
    final token = await _token();

    return ApiService.dio.get(
      "/notifications",
      queryParameters: {"page": page},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> unreadCount() async {
    final token = await _token();

    return ApiService.dio.get(
      "/notifications/unread-count",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> markRead(int id) async {
    final token = await _token();

    return ApiService.dio.put(
      "/notifications/$id/read",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> markAllRead() async {
    final token = await _token();

    return ApiService.dio.put(
      "/notifications/read-all",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
