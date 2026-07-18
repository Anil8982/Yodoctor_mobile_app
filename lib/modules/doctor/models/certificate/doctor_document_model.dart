class DoctorDocumentModel {
  final int id;
  final String fileUrl;
  final DateTime createdAt;

  const DoctorDocumentModel({
    required this.id,
    required this.fileUrl,
    required this.createdAt,
  });

  factory DoctorDocumentModel.fromJson(Map<String, dynamic> json) {
    return DoctorDocumentModel(
      id: json["id"],
      fileUrl: json["file_url"] ?? "",
      createdAt: DateTime.parse(
        json["created_at"] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  String get fileName {
    return fileUrl.split("/").last;
  }
}
