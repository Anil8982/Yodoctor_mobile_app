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

  factory AppointmentHistoryItem.fromJson(Map<String, dynamic> json) {
    return AppointmentHistoryItem(
      id: json['id']?.toString() ?? '',
      doctorName: json['doctorName'] ?? json['doctor_name'] ?? '',
      specialty: json['specialty'] ?? '',
      patientLabel:
          json['patientLabel'] ??
          json['patient_label'] ??
          json['full_name'] ??
          '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      shift: json['shift'] ?? '',
      tokenNumber:
          json['tokenNumber'] ?? json['token_number']?.toString() ?? '',
      status: json['status'] ?? 'PENDING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'specialty': specialty,
      'patientLabel': patientLabel,
      'date': date.toIso8601String(),
      'shift': shift,
      'tokenNumber': tokenNumber,
      'status': status,
    };
  }
}
