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

  factory LiveQueueItem.fromJson(Map<String, dynamic> json) {
    return LiveQueueItem(
      id: json["id"].toString(),
      tokenNumber: json["token_number"].toString(),
      status: json["status"] ?? "",
      patientName:
          json["patientName"] ??
          json["familyMemberName"] ??
          json["walk_in_patient_name"] ??
          "",
      familyMemberName: json["familyMemberName"],
      walkInPatientName: json["walk_in_patient_name"],
      patientImage: json["patientImage"],
      hasPrescription: json["hasPrescription"] ?? false,
    );
  }
}
