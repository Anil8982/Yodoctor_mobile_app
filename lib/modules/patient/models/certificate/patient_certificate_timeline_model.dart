class PatientCertificateTimelineModel {
  final int id;
  final String label;
  final String state;
  final String? note;
  final DateTime createdAt;

  const PatientCertificateTimelineModel({
    required this.id,
    required this.label,
    required this.state,
    this.note,
    required this.createdAt,
  });

  factory PatientCertificateTimelineModel.fromJson(Map<String, dynamic> json) {
    return PatientCertificateTimelineModel(
      id: json["id"],

      label: json["label"],

      state: json["state"],

      note: json["note"],

      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}
