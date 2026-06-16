class DoctorDashboardProfile {
  // Tab 1: Personal Info
  final String id;
  final String fullName;
  final String email;
  final String mobile;
  final String gender;
  final String aboutYou;
  final String? profilePictureUrl;

  // Tab 2: Professional Info
  final String primaryQualification;
  final String specialization;
  final int experienceYears;
  final String registrationNumber;
  final String stateCouncil;
  final String registrationValidTill;

  // Tab 3: Clinic Details
  final String clinicName;
  final String city;
  final String state;
  final String pincode;
  final String landmark;
  final String googleMapsLink;
  final String fullAddress;

  // Tab 4: Practice Type
  final String practiceType;
  final String? affiliatedHospitalName;

  // Tab 5: Consultation Timings
  final int consultationFee;
  final int avgDurationMinutes;
  final List<String> availableDays;
  final Map<String, dynamic> shiftTimings;

  // Tab 6: Documents
  final List<Map<String, String>> documents;

  const DoctorDashboardProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.aboutYou,
    this.profilePictureUrl,
    required this.primaryQualification,
    required this.specialization,
    required this.experienceYears,
    required this.registrationNumber,
    required this.stateCouncil,
    required this.registrationValidTill,
    required this.clinicName,
    required this.city,
    required this.state,
    required this.pincode,
    required this.landmark,
    required this.googleMapsLink,
    required this.fullAddress,
    required this.practiceType,
    this.affiliatedHospitalName,
    required this.consultationFee,
    required this.avgDurationMinutes,
    required this.availableDays,
    required this.shiftTimings,
    required this.documents,
  });

  factory DoctorDashboardProfile.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardProfile(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Male',
      aboutYou: json['aboutYou'] as String? ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String?,
      primaryQualification: json['primaryQualification'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      experienceYears: json['experienceYears'] as int? ?? 0,
      registrationNumber: json['registrationNumber'] as String? ?? '',
      stateCouncil: json['stateCouncil'] as String? ?? '',
      registrationValidTill: json['registrationValidTill'] as String? ?? '',
      clinicName: json['clinicName'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      landmark: json['landmark'] as String? ?? '',
      googleMapsLink: json['googleMapsLink'] as String? ?? '',
      fullAddress: json['fullAddress'] as String? ?? '',
      practiceType: json['practiceType'] as String? ?? 'Solo Practice',
      affiliatedHospitalName: json['affiliatedHospitalName'] as String?,
      consultationFee: json['consultationFee'] as int? ?? 0,
      avgDurationMinutes: json['avgDurationMinutes'] as int? ?? 20,
      availableDays: List<String>.from(json['availableDays'] ?? []),
      shiftTimings: Map<String, dynamic>.from(json['shiftTimings'] ?? {}),
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'mobile': mobile,
      'gender': gender,
      'aboutYou': aboutYou,
      'profilePictureUrl': profilePictureUrl,
      'primaryQualification': primaryQualification,
      'specialization': specialization,
      'experienceYears': experienceYears,
      'registrationNumber': registrationNumber,
      'stateCouncil': stateCouncil,
      'registrationValidTill': registrationValidTill,
      'clinicName': clinicName,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
      'googleMapsLink': googleMapsLink,
      'fullAddress': fullAddress,
      'practiceType': practiceType,
      'affiliatedHospitalName': affiliatedHospitalName,
      'consultationFee': consultationFee,
      'avgDurationMinutes': avgDurationMinutes,
      'availableDays': availableDays,
      'shiftTimings': shiftTimings,
      'documents': documents,
    };
  }
}