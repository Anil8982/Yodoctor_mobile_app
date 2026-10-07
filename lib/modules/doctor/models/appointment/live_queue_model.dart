class LiveQueueItem {
  final String id;
  final String tokenNumber;
  final String status;
  final String patientName;
  final String? familyMemberName;
  final String? walkInPatientName;
  final String? patientImage;
  final bool hasPrescription;

  const LiveQueueItem({
    required this.id,
    required this.tokenNumber,
    required this.status,
    required this.patientName,
    this.familyMemberName,
    this.walkInPatientName,
    this.patientImage,
    required this.hasPrescription,
  });

  /// True only when this appointment belongs to a walk-in patient.
  bool get isWalkIn {
    final walkIn = walkInPatientName?.trim() ?? '';
    final family = familyMemberName?.trim() ?? '';

    return walkIn.isNotEmpty && family.isEmpty;
  }

  factory LiveQueueItem.fromJson(Map<String, dynamic> json) {
    final registeredPatientName =
        json["patientName"]?.toString().trim() ?? '';

    final familyName =
        json["familyMemberName"]?.toString().trim() ?? '';

    final walkInName =
        json["walk_in_patient_name"]?.toString().trim() ?? '';

    String resolvedPatientName;

    if (familyName.isNotEmpty) {
      resolvedPatientName = familyName;
    } else if (registeredPatientName.isNotEmpty) {
      resolvedPatientName = registeredPatientName;
    } else if (walkInName.isNotEmpty) {
      resolvedPatientName = walkInName;
    } else {
      resolvedPatientName = 'Unknown Patient';
    }

    return LiveQueueItem(
      id: json["id"]?.toString() ?? '',

      tokenNumber:
      json["token_number"]?.toString() ?? '',

      status:
      json["status"]?.toString() ?? '',

      patientName: resolvedPatientName,

      familyMemberName:
      familyName.isNotEmpty ? familyName : null,

      walkInPatientName:
      walkInName.isNotEmpty ? walkInName : null,

      patientImage:
      json["patientImage"]?.toString(),

      hasPrescription:
      json["hasPrescription"] == true ||
          json["hasPrescription"] == 1,
    );
  }
}