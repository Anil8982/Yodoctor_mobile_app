import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class SubscriptionApi {
  Future<Response> getActiveSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("doctor_token");

    return ApiService.dio.get(
      "/subscriptions/active",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getBillingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("doctor_token");

    return ApiService.dio.get(
      "/billing/history",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> getPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("doctor_token");

    return ApiService.dio.get(
      "/plans",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> createSubscription({
    required String planId,
    String billing = "monthly",
    bool isUpgrade = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("doctor_token");

    return ApiService.dio.post(
      "/subscriptions/create",
      data: {"planId": planId, "billing": billing, "isUpgrade": isUpgrade},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  Future<Response> verifySubscription(Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("doctor_token");

    return ApiService.dio.post(
      "/subscriptions/verify",
      data: body,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
