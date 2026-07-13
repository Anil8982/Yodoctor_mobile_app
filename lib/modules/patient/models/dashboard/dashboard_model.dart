import 'appointment_model.dart';
import 'today_token_model.dart';
import 'patient_model.dart';

class DashboardModel {
  final PatientModel patient;
  final String patientName;
  final int upcomingCount;
  final TodayTokenModel? todayToken;
  final List<AppointmentModel> appointments;

  DashboardModel({
    required this.patient,
    required this.patientName,
    required this.upcomingCount,
    required this.todayToken,
    required this.appointments,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      patient: PatientModel.fromJson(json["patient"] ?? {}),

      patientName: json["patientName"] ?? "",

      upcomingCount: json["upcomingCount"] ?? 0,

      todayToken: json["todayToken"] == null
          ? null
          : TodayTokenModel.fromJson(json["todayToken"]),

      appointments: (json["appointments"] as List? ?? [])
          .map((e) => AppointmentModel.fromJson(e))
          .toList(),
    );
  }
}
