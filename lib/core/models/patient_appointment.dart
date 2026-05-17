class PatientAppointment {
  const PatientAppointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.dateTime,
    required this.status,
    required this.isOnline,
    required this.patientName,
    required this.appointmentStatus,
  });

  final String id;
  final String doctorName;
  final String specialty;
  final String hospital;
  final DateTime dateTime;
  final String status;
  final bool isOnline;
  final String patientName;
  final String appointmentStatus;
}
