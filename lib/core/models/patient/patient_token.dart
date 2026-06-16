class PatientToken {
  const PatientToken({
    required this.tokenNumber,
    required this.patientsAhead,
    required this.estimatedTime,
    required this.clinicName,
    required this.nowServing,
  });

  final String tokenNumber;
  final int patientsAhead;
  final String estimatedTime;
  final String clinicName;
  final String nowServing;
}
