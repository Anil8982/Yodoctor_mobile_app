class SessionTimings {
  final String morning;
  final String evening;

  SessionTimings({required this.morning, required this.evening});

  factory SessionTimings.fromJson(Map<String, dynamic> json) {
    return SessionTimings(
      morning: json["morning"] ?? "",
      evening: json["evening"] ?? "",
    );
  }
}

class DoctorDetailModel {
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String qualification;
  final String clinicName;
  final String address;
  final String city;
  final String licenseNumber;
  final double consultationFee;
  final int experienceYears;
  final double rating;
  final String languages;
  final String description;
  final SessionTimings sessionTimings;
  final String profileImage;
  final List<String> availableDays;
  final int isAvailable;

  DoctorDetailModel({
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.qualification,
    required this.clinicName,
    required this.address,
    required this.city,
    required this.licenseNumber,
    required this.consultationFee,
    required this.experienceYears,
    required this.rating,
    required this.languages,
    required this.description,
    required this.sessionTimings,
    required this.profileImage,
    required this.availableDays,
    this.isAvailable = 1,
  });

  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailModel(
      doctorId: json["doctorId"]?.toString() ?? "0",

      doctorName: json["doctorName"] ?? "",
      specialization: json["specialization"] ?? "",
      qualification: json["qualification"] ?? "",
      clinicName: json["clinicName"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      licenseNumber: json["licenseNumber"] ?? "",

      consultationFee: double.tryParse(json["consultationFee"].toString()) ?? 0,

      experienceYears: json["experience_years"] is int
          ? json["experience_years"]
          : int.tryParse(json["experience_years"]?.toString() ?? "0") ?? 0,

      rating: double.tryParse(json["rating"].toString()) ?? 0,

      languages: json["languages"] is List
          ? (json["languages"] as List).join(", ")
          : json["languages"]?.toString() ?? "",

      description: json["description"] ?? "",

      // Safe fallback handled cleanly
      sessionTimings: SessionTimings.fromJson(json["sessionTimings"] ?? {}),

      profileImage: json["profile_image"] ?? "",
      availableDays:
          (json["availableDays"] as List?)?.map((e) => e.toString()).toList() ??
          [],
      isAvailable: json["is_available"] is int
          ? json["is_available"] as int
          : int.tryParse(json["is_available"]?.toString() ?? "0") ?? 0,
    );
  }
}
