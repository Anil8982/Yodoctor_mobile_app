class DoctorCertificateDetailModel {
  final int id;

  final String fullName;
  final String certificateType;

  final String purpose;
  final String medicalConditions;

  final String gender;

  final String notes;
  final String medications;

  final DateTime? dob;

  final String status;

  const DoctorCertificateDetailModel({
    required this.id,
    required this.fullName,
    required this.certificateType,
    required this.purpose,
    required this.medicalConditions,
    required this.gender,
    required this.notes,
    required this.medications,
    required this.status,
    this.dob,
  });

  factory DoctorCertificateDetailModel.fromJson(Map<String, dynamic> json) {
    return DoctorCertificateDetailModel(
      id: json["id"],

      fullName: json["full_name"] ?? "",

      certificateType: json["certificate_type"] ?? "",

      purpose: json["purpose"] ?? "",

      medicalConditions: json["medical_conditions"] ?? "",

      gender: json["gender"] ?? "",

      notes: json["notes"] ?? "",

      medications: json["medications"] ?? "",

      status: json["status"] ?? "",

      dob: json["dob"] != null ? DateTime.parse(json["dob"]) : null,
    );
  }
}
