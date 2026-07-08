class DoctorReviewModel {
  final int id;
  final String patientName;
  final String? patientImage;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const DoctorReviewModel({
    required this.id,
    required this.patientName,
    required this.patientImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory DoctorReviewModel.fromJson(Map<String, dynamic> json) {
    return DoctorReviewModel(
      id: json["id"],
      patientName: json["patientName"] ?? "",
      patientImage: json["patientImage"],
      rating: (json["rating"] as num).toDouble(),
      comment: json["comment"] ?? "",
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}
