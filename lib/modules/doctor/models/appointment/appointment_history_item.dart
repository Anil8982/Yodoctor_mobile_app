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
    required this.isWalkIn,
    required this.hasPrescription,
  });

  final String id;
  final String doctorName;
  final String specialty;
  final String patientLabel;
  final DateTime date;
  final String shift;
  final String tokenNumber;
  final String status;

  // Used to prevent prescription actions for walk-in patients.
  final bool isWalkIn;

  // Indicates whether a prescription already exists.
  final bool hasPrescription;

  factory AppointmentHistoryItem.fromJson(Map<String, dynamic> json) {
    final patientName =
        json['patientName']?.toString().trim() ?? '';

    final familyMemberName =
        json['familyMemberName']?.toString().trim() ?? '';

    final walkInPatientName =
        json['walk_in_patient_name']?.toString().trim() ?? '';

    // A patient is considered walk-in only when there is a walk-in name
    // and there is no linked registered patient/family member.
    final bool isWalkIn =
        walkInPatientName.isNotEmpty &&
            patientName.isEmpty &&
            familyMemberName.isEmpty;

    String resolvedPatientName;

    if (familyMemberName.isNotEmpty) {
      resolvedPatientName = familyMemberName;
    } else if (patientName.isNotEmpty) {
      resolvedPatientName = patientName;
    } else if (walkInPatientName.isNotEmpty) {
      resolvedPatientName = walkInPatientName;
    } else {
      resolvedPatientName = 'Unknown Patient';
    }

    DateTime parsedDate = DateTime.now();

    final rawDate =
        json['appointment_date'] ??
            json['date'];

    if (rawDate != null) {
      parsedDate =
          DateTime.tryParse(rawDate.toString()) ??
              DateTime.now();
    }

    final rawHasPrescription = json['hasPrescription'];

    final bool hasPrescription =
        rawHasPrescription == true ||
            rawHasPrescription == 1 ||
            rawHasPrescription?.toString() == '1' ||
            rawHasPrescription?.toString().toLowerCase() == 'true';

    return AppointmentHistoryItem(
      id: json['id']?.toString() ?? '',

      doctorName:
      json['doctorName']?.toString() ??
          json['doctor_name']?.toString() ??
          '',

      specialty:
      json['specialty']?.toString() ?? '',

      patientLabel: resolvedPatientName,

      date: parsedDate,

      shift:
      json['appointment_slot']?.toString() ??
          json['shift']?.toString() ??
          '',

      tokenNumber:
      json['tokenNumber']?.toString() ??
          json['token_number']?.toString() ??
          '',

      status:
      json['status']?.toString() ??
          'PENDING',

      isWalkIn: isWalkIn,

      hasPrescription: hasPrescription,
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
      'isWalkIn': isWalkIn,
      'hasPrescription': hasPrescription,
    };
  }
}