import 'package:yodoctor/core/models/patient/patient_appointment.dart';

import 'admin_user.dart';

class AdminDashboardData {
  final AdminUser admin;
  final int totalDoctors;
  final int totalPatients;
  final int todaysAppointments;
  final int pendingApprovals;

  final List<PatientAppointment> appointments;
  final int totalAppointments;
  final int completedAppointments;
  final int cancelledAppointments;
  final int pendingAppointments;

  const AdminDashboardData({
    required this.admin,
    required this.totalDoctors,
    required this.totalPatients,
    required this.appointments,
    required this.todaysAppointments,
    required this.pendingApprovals,
    required this.totalAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.pendingAppointments,
  });

  AdminDashboardData copyWith({
    AdminUser? admin,
    int? totalDoctors,
    int? totalPatients,
    int? todaysAppointments,
    int? pendingApprovals,
    List<PatientAppointment>? appointments,
    int? totalAppointments,
    int? completedAppointments,
    int? cancelledAppointments,
    int? pendingAppointments,
  }) {
    return AdminDashboardData(
      admin: admin ?? this.admin,
      totalDoctors: totalDoctors ?? this.totalDoctors,
      totalPatients: totalPatients ?? this.totalPatients,
      todaysAppointments: todaysAppointments ?? this.todaysAppointments,
      pendingApprovals: pendingApprovals ?? this.pendingApprovals,
      appointments: appointments ?? this.appointments,

      totalAppointments: totalAppointments ?? this.totalAppointments,
      completedAppointments:
          completedAppointments ?? this.completedAppointments,
      cancelledAppointments:
          cancelledAppointments ?? this.cancelledAppointments,
      pendingAppointments: pendingAppointments ?? this.pendingAppointments,
    );
  }
}
