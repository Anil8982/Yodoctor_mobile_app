import 'patient_appointment.dart';
import 'patient_token.dart';
import '../../../modules/auth/models/patient_user.dart';

class PatientDashboardData {
  const PatientDashboardData({
    required this.user,
    required this.upcomingVisitsCount,
    required this.todayToken,
    required this.appointments,
  });

  final PatientUser user;
  final int upcomingVisitsCount;
  final PatientToken todayToken;
  final List<PatientAppointment> appointments;
}
