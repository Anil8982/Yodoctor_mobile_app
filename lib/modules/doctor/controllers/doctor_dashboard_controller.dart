import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/doctor/doctor_dashboard_data.dart';
import '../../../core/utils/dummy_data.dart';

class DoctorDashboardNotifier extends AsyncNotifier<DoctorDashboardData> {
  @override
  Future<DoctorDashboardData> build() async {
    return await DummyData.getDoctorDashboardData();
  }

  Future<void> loadDashboard() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await DummyData.getDoctorDashboardData();
    });
  }

  Future<void> toggleAvailability(bool available) async {
    final previousState = state;
    if (!previousState.hasValue) return;

    final updatedData = previousState.value!.copyWith(isAvailable: available);
    state = AsyncValue.data(updatedData);

    try {
      await DummyData.toggleDoctorAvailability(available);

      final freshData = await DummyData.getDoctorDashboardData();
      state = AsyncValue.data(freshData);
    } catch (error, stackTrace) {
      state = AsyncValue.data(previousState.value!.copyWith(isAvailable: !available));
      state = AsyncValue.error('Failed to update availability status.', stackTrace);
    }
  }
}

final doctorDashboardProvider = AsyncNotifierProvider.autoDispose<DoctorDashboardNotifier, DoctorDashboardData>(
  DoctorDashboardNotifier.new,
);