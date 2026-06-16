import 'doctor_dashboard_profile.dart';

class DoctorDashboardData {
  const DoctorDashboardData({
    required this.doctor,
    required this.pendingRequests,
    required this.todayQueueCount,
    required this.completedTodayCount,
    required this.isAvailable,
  });

  final DoctorDashboardProfile doctor;

  final int pendingRequests;
  final int todayQueueCount;
  final int completedTodayCount;
  final bool isAvailable;

  DoctorDashboardData copyWith({
    DoctorDashboardProfile? doctor,
    int? pendingRequests,
    int? todayQueueCount,
    int? completedTodayCount,
    bool? isAvailable,
  }) {
    return DoctorDashboardData(
      doctor: doctor ?? this.doctor,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      todayQueueCount: todayQueueCount ?? this.todayQueueCount,
      completedTodayCount: completedTodayCount ?? this.completedTodayCount,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}