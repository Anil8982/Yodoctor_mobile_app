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
}
