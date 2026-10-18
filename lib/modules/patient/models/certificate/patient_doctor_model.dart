class PatientDoctorModel {
  final int id;
  final String name;
  final String specialty;
  final int experience;
  final double rating;
  final String? image;
  final double certificateFee;

  const PatientDoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.rating,
    this.image,
    this.certificateFee = 0.0,
  });

  factory PatientDoctorModel.fromJson(Map<String, dynamic> json) {
    return PatientDoctorModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['doctorName']?.toString() ?? '',
      specialty: json['specialization']?.toString() ?? '',
      experience: json['experience_years'] is int
          ? json['experience_years']
          : int.tryParse(
        json['experience_years']?.toString() ?? '0',
      ) ??
          0,
      rating: double.tryParse(
        json['rating']?.toString() ?? '0',
      ) ??
          0.0,
      image: json['profile_image']?.toString(),
      certificateFee: double.tryParse(
        json['certificate_fee']?.toString() ?? '0',
      ) ??
          0.0,
    );
  }
}