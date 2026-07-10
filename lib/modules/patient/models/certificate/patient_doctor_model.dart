class PatientDoctorModel {
  final int id;
  final String name;
  final String specialty;
  final int experience;
  final double rating;
  final String? image;

  const PatientDoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.rating,
    this.image,
  });

  factory PatientDoctorModel.fromJson(Map<String, dynamic> json) {
    return PatientDoctorModel(
      id: json["_id"] is int
          ? json["_id"]
          : (json["id"] is int ? json["id"] : int.tryParse(json["_id"]?.toString() ?? json["id"]?.toString() ?? "0") ?? 0),

      name: json["doctorName"] ?? "",
      specialty: json["specialization"] ?? "",
      experience: json["experience_years"] ?? 0,

      rating: double.tryParse(json["rating"]?.toString() ?? "0") ?? 0.0,

      image: json["profile_image"],
    );
  }
}