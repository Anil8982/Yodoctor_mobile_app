class AppointmentQueueInfo {
  const AppointmentQueueInfo({
    required this.doctorName,
    required this.specialty,
    required this.patientLabel,
    required this.tokenNumber,
    required this.nowServing,
    required this.estimatedWait,
  });

  final String doctorName;
  final String specialty;
  final String patientLabel;
  final String tokenNumber;
  final String nowServing;
  final String estimatedWait;
}
