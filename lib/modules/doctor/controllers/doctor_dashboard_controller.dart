import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/dashboard/doctor_dashboard_data.dart';
import '../repositories/doctor_dashboard_repository.dart';

final doctorDashboardProvider =
AsyncNotifierProvider<DoctorDashboardNotifier, DoctorDashboardData>(
  DoctorDashboardNotifier.new,
);

class DoctorDashboardNotifier extends AsyncNotifier<DoctorDashboardData> {
  static const String _subTag = 'DoctorDashboardNotifier';

  @override
  Future<DoctorDashboardData> build() async {
    AppLogger.info('Initializing Doctor Dashboard telemetry pipeline', tag: LogTags.doctor, subTag: _subTag);
    return await _fetchDashboard();
  }

  Future<DoctorDashboardData> _fetchDashboard() async {
    final repository = ref.read(doctorDashboardRepositoryProvider);
    final response = await repository.getDashboard();
    final statusCode = response.statusCode ?? 0;

    // 🎯 FIXED: Bulletproof status code check mapping with proper error logging
    if (statusCode < 200 || statusCode >= 300) {
      final errorMsg = response.data["message"] ?? "Failed to load dashboard metrics";
      AppLogger.warning('Dashboard API error response. Status: $statusCode, Message: $errorMsg', tag: LogTags.doctor, subTag: _subTag);
      throw Exception(errorMsg);
    }

    return DoctorDashboardData.fromJson(response.data);
  }

  Future<void> loadDashboard() async {
    state = const AsyncLoading();
    AppLogger.info('Triggering manual dashboard sync operation...', tag: LogTags.doctor, subTag: _subTag);

    state = await AsyncValue.guard(() async {
      final freshData = await _fetchDashboard();
      AppLogger.success('Dashboard data synchronized seamlessly', tag: LogTags.doctor, subTag: _subTag);
      return freshData;
    });
  }

  Future<void> toggleAvailability(bool available) async {
    final previous = state.value;
    if (previous == null) return;

    AppLogger.info('Toggling availability state checkpoint to: $available', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorDashboardRepositoryProvider);
      final response = await repository.updateAvailability(available);
      final statusCode = response.statusCode ?? 0;

      if (statusCode < 200 || statusCode >= 300) {
        throw Exception(response.data["message"] ?? "Availability status transaction rejected");
      }

      final fresh = await _fetchDashboard();
      state = AsyncData(fresh);
      AppLogger.success('Availability state locked and saved successfully', tag: LogTags.doctor, subTag: _subTag);
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Availability toggle engine exception', tag: LogTags.doctor, subTag: _subTag);

      state = AsyncData(previous);
    }
  }
}