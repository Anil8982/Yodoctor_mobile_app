import 'doctor_profile.dart';

class DoctorDashboardData {
  const DoctorDashboardData({
    required this.doctor,
    required this.pendingRequests,
    required this.todayQueueCount,
    required this.completedTodayCount,
    required this.isAvailable,
  });

  final DoctorProfile doctor;
  final int pendingRequests;
  final int todayQueueCount;
  final int completedTodayCount;
  final bool isAvailable;

  DoctorDashboardData copyWith({
    DoctorProfile? doctor,
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
