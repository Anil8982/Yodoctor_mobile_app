class AppointmentHistoryItem {
  const AppointmentHistoryItem({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.patientLabel,
    required this.date,
    required this.shift,
    required this.tokenNumber,
    required this.status,
  });

  final String id;
  final String doctorName;
  final String specialty;
  final String patientLabel;
  final DateTime date;
  final String shift;
  final String tokenNumber;
  final String status;
}
