class DoctorProfileModel {
  final String id;
  final String doctorName;
  final String email;
  final String mobile;
  final String gender;
  final String bio;

  final String degree;
  final String specialization;
  final int experienceYears;
  final String licenseNumber;
  final String stateCouncil;
  final String validTill;

  final String clinicName;
  final String city;
  final String state;
  final String pincode;
  final String landmark;
  final String mapsLink;
  final String address;
  final bool isAvailable;
  final String practiceType;
  final String? hospitalName;

  final int consultationFee;
  final int consultationDuration;

  final List<String> availableDays;
  final List<dynamic> availability;

  final Map<String, dynamic> documents;

  final List<String> languages;

  final double rating;
  final int totalReviews;

  const DoctorProfileModel({
    required this.id,
    required this.doctorName,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.bio,
    required this.degree,
    required this.isAvailable,
    required this.specialization,
    required this.experienceYears,
    required this.licenseNumber,
    required this.stateCouncil,
    required this.validTill,
    required this.clinicName,
    required this.city,
    required this.state,
    required this.pincode,
    required this.landmark,
    required this.mapsLink,
    required this.address,
    required this.practiceType,
    this.hospitalName,
    required this.consultationFee,
    required this.consultationDuration,
    required this.availableDays,
    required this.availability,
    required this.documents,
    required this.languages,
    required this.rating,
    required this.totalReviews,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    final clinic = json["clinic"] is Map<String, dynamic>
        ? json["clinic"] as Map<String, dynamic>
        : <String, dynamic>{};
    final consultationDurationRaw =
        json["consultation_duration"]?.toString() ?? "";

    return DoctorProfileModel(
      id: json["id"]?.toString() ?? "",
      doctorName: json["doctorName"] ?? "",
      email: json["email"] ?? "",
      mobile: json["mobile"] ?? "",
      gender: json["gender"] ?? "",
      bio: json["bio"] ?? "",
      degree: json["degree"] ?? "",
      specialization: json["specialization"] ?? "",
      experienceYears: json["experienceYears"] ?? json["experience_years"] ?? 0,
      licenseNumber: json["licenseNumber"] ?? "",
      stateCouncil: json["state_council"] ?? "",
      validTill: json["valid_till"] ?? "",
      consultationFee: json["consultationFee"] ?? 0,

      consultationDuration:
          int.tryParse(
            consultationDurationRaw.replaceAll(RegExp(r'[^0-9]'), ''),
          ) ??
          15,
      practiceType: json["practice_type"] ?? "",
      hospitalName: json["hospital_name"],
      availableDays: List<String>.from(json["availableDays"] ?? []),
      availability: json["availability"] is List
          ? List<dynamic>.from(json["availability"])
          : [],
      rating: (json["rating"] ?? 0).toDouble(),
      isAvailable: json["isAvailable"] == true || json["isAvailable"] == 1,
      totalReviews: json["total_reviews"] ?? 0,
      clinicName: clinic["clinic_name"] ?? json["clinic_name"] ?? "",
      city: clinic["city"] ?? json["city"] ?? "",
      state: clinic["state"] ?? json["state"] ?? "",
      pincode: clinic["pincode"] ?? json["pincode"] ?? "",
      landmark: clinic["landmark"] ?? json["landmark"] ?? "",
      mapsLink: clinic["mapsLink"] ?? json["mapsLink"] ?? "",
      address: clinic["address"] ?? json["address"] ?? "",
      languages: clinic["languages"] is List
          ? List<String>.from(clinic["languages"])
          : [],
      documents: json["documents"] is Map
          ? Map<String, dynamic>.from(json["documents"])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "doctorName": doctorName,
      "degree": degree,
      "specialization": specialization,
      "bio": bio,
      "consultationFee": consultationFee,
      "consultation_duration": consultationDuration,
      "experience_years": experienceYears,
      "licenseNumber": licenseNumber,
      "state_council": stateCouncil,
      "valid_till": validTill,
      "practice_type": practiceType,
      "hospital_name": hospitalName,
      "availableDays": availableDays,
      "languages": languages,
      "clinic_name": clinicName,
      "city": city,
      "address": address,
      "state": state,
      "pincode": pincode,
      "landmark": landmark,
      "mapsLink": mapsLink,
      "mobile": mobile,
      "isAvailable": isAvailable,
    };
  }

  DoctorProfileModel copyWith({
    bool? isAvailable,
    String? doctorName,
    String? specialization,
    int? experienceYears,
  }) {
    return DoctorProfileModel(
      id: id,
      doctorName: doctorName ?? this.doctorName,
      email: email,
      mobile: mobile,
      gender: gender,
      bio: bio,
      degree: degree,
      specialization: specialization ?? this.specialization,
      experienceYears: experienceYears ?? this.experienceYears,
      licenseNumber: licenseNumber,
      stateCouncil: stateCouncil,
      validTill: validTill,
      clinicName: clinicName,
      city: city,
      state: state,
      pincode: pincode,
      landmark: landmark,
      mapsLink: mapsLink,
      address: address,
      practiceType: practiceType,
      hospitalName: hospitalName,
      consultationFee: consultationFee,
      consultationDuration: consultationDuration,
      availableDays: availableDays,
      availability: availability,
      documents: documents,
      languages: languages,
      rating: rating,
      totalReviews: totalReviews,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
