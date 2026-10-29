import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
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
    DebugLog.info(
      'Initializing Doctor Dashboard telemetry pipeline',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    return await _fetchDashboard();
  }

  Future<DoctorDashboardData> _fetchDashboard() async {
    final repository = ref.read(doctorDashboardRepositoryProvider);

    final response = await repository.getDashboard();

    if (!ref.mounted) {
      throw Exception('Provider disposed');
    }

    final statusCode = response.statusCode ?? 0;

    if (statusCode < 200 || statusCode >= 300) {
      final errorMsg =
          response.data["message"] ?? "Failed to load dashboard metrics";

      DebugLog.warning(
        'Dashboard API error response. Status: $statusCode, Message: $errorMsg',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      throw Exception(errorMsg);
    }

    return DoctorDashboardData.fromJson(response.data);
  }

  Future<void> loadDashboard() async {
    // Preserve existing data before refresh
    final previous = state.value;

    DebugLog.info(
      'Triggering manual dashboard sync operation...',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final freshData = await _fetchDashboard();
      state = AsyncData(freshData);
      DebugLog.success(
        'Dashboard data synchronized seamlessly',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    } catch (e, st) {
      DebugLog.error(
        error: e,
        stackTrace: st,
        'Dashboard refresh failed',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      if (previous != null) {
        // Refresh failed → keep existing dashboard data
        state = AsyncData(previous);
        DebugLog.info(
          'Preserved previous dashboard data during refresh failure',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      } else {
        // No previous data → show error state
        state = AsyncError(e, st);
      }
    }
  }

  Future<void> toggleAvailability(bool available) async {
    final previous = state.value;
    if (previous == null) return;

    DebugLog.info(
      'Toggling availability state checkpoint to: $available',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorDashboardRepositoryProvider);
      final response = await repository.updateAvailability(available);
      final statusCode = response.statusCode ?? 0;

      if (statusCode < 200 || statusCode >= 300) {
        throw Exception(
          response.data["message"] ??
              "Availability status transaction rejected",
        );
      }

      final fresh = await _fetchDashboard();
      state = AsyncData(fresh);
      DebugLog.success(
        'Availability state locked and saved successfully',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    } catch (e, st) {
      DebugLog.error(
        error: e,
        stackTrace: st,
        'Availability toggle engine exception',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      // Preserve previous data on error
      state = AsyncData(previous);
    }
  }
}
