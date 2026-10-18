class DoctorSearchModel {
  final int doctorId;
  final String doctorName;
  final String specialization;
  final String clinicName;
  final String city;
  final double rating;
  final double consultationFee;
  final int experience;
  final String profileImage;
  final int isAvailable;

  DoctorSearchModel({
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.clinicName,
    required this.city,
    required this.rating,
    required this.consultationFee,
    required this.experience,
    required this.profileImage,
    this.isAvailable = 1,
  });

  factory DoctorSearchModel.fromJson(Map<String, dynamic> json) {
    return DoctorSearchModel(
      doctorId: json["doctorId"] ?? 0,
      doctorName: json["doctorName"] ?? "",
      specialization: json["specialization"] ?? "",
      clinicName: json["clinicName"] ?? "",
      city: json["city"] ?? "",
      rating: double.tryParse("${json["rating"] ?? 0}") ?? 0,
      consultationFee: double.tryParse("${json["consultationFee"] ?? 0}") ?? 0,
      experience: json["experience"] ?? 0,
      profileImage: json["profile_image"] ?? "",
      isAvailable: json["is_available"] ?? 0,
    );
  }

  String get name => doctorName;

  String get specialty => specialization;

  String get hospital => clinicName;

  String get location => city;

  int get experienceYears => experience;
}
