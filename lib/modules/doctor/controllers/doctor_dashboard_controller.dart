import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/doctor/doctor_dashboard_data.dart';
import '../../../services/doctor_dashboard_service.dart';

class DoctorDashboardNotifier extends AsyncNotifier<DoctorDashboardData> {
  final DoctorDashboardService _service = DoctorDashboardService();

  @override
  Future<DoctorDashboardData> build() async {
    return await _fetchDashboard();
  }

  Future<DoctorDashboardData> _fetchDashboard() async {
    final response = await _service.getDashboard();

    if (response.statusCode != 200) {
      throw Exception(response.data["message"] ?? "Failed to load dashboard");
    }

    return DoctorDashboardData.fromJson(response.data);
  }

  Future<void> loadDashboard() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await _fetchDashboard();
    });
  }

  Future<void> toggleAvailability(bool available) async {
    final previous = state.value;

    if (previous == null) return;

    try {
      final response = await _service.updateAvailability(available);

      if (response.statusCode != 200) {
        throw Exception(response.data["message"]);
      }

      final fresh = await _fetchDashboard();

      state = AsyncData(fresh);
    } catch (e, st) {
      state = AsyncError(e, st);

      // Old data restore
      state = AsyncData(previous);
    }
  }
}

final doctorDashboardProvider =
    AsyncNotifierProvider<DoctorDashboardNotifier, DoctorDashboardData>(
      DoctorDashboardNotifier.new,
    );
