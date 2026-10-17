import 'doctor_profile_model.dart';

class DoctorDashboardData {
  final DoctorProfileModel doctor;

  final int pendingRequests;
  final int todayQueue;
  final int tomorrow;
  final int nextDay;
  final int completedToday;
  final int totalPatients;

  const DoctorDashboardData({
    required this.doctor,
    required this.pendingRequests,
    required this.todayQueue,
    required this.tomorrow,
    required this.nextDay,
    required this.completedToday,
    required this.totalPatients,
  });

  factory DoctorDashboardData.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardData(
      doctor: DoctorProfileModel.fromJson(json["doctor"] ?? {}),
      pendingRequests: json["pendingRequests"] ?? 0,
      todayQueue: json["todayQueue"] ?? 0,
      tomorrow: json["tomorrow"] ?? 0,
      nextDay: json["nextDay"] ?? 0,
      completedToday: json["completedToday"] ?? 0,
      totalPatients: json["totalPatients"] ?? 0,
    );
  }

  DoctorDashboardData copyWith({
    DoctorProfileModel? doctor,
    int? pendingRequests,
    int? todayQueue,
    int? tomorrow,
    int? nextDay,
    int? completedToday,
    int? totalPatients,
  }) {
    return DoctorDashboardData(
      doctor: doctor ?? this.doctor,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      todayQueue: todayQueue ?? this.todayQueue,
      tomorrow: tomorrow ?? this.tomorrow,
      nextDay: nextDay ?? this.nextDay,
      completedToday: completedToday ?? this.completedToday,
      totalPatients: totalPatients ?? this.totalPatients,
    );
  }
}
