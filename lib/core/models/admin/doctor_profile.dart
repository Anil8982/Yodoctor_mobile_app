class DoctorProfile {
  const DoctorProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.consultationFee,
    required this.distanceKm,
    required this.availableSlot,
    required this.languages,
    required this.location,
  });

  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final int consultationFee;
  final double distanceKm;
  final String availableSlot;
  final List<String> languages;
  final String location;

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      hospital: json['hospital'] as String,
      experienceYears: json['experienceYears'] as int,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      consultationFee: json['consultationFee'] as int,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      availableSlot: json['availableSlot'] as String,
      languages: List<String>.from(json['languages'] ?? []),
      location: json['location'] as String,
    );
  }
}