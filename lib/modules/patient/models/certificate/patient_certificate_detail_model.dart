class PatientCertificateDetailModel {
  final int id;
  final String fullName;
  final String doctorName;
  final String certificateType;
  final String purpose;
  final String status;

  final String gender;
  final String bloodGroup;

  final String medicalConditions;
  final String medications;
  final String notes;

  final DateTime? dob;
  final DateTime createdAt;

  final String? certificateId;
  final String? certificateFile;

  final DateTime? issuedAt;
  final DateTime? expiryDate;

  const PatientCertificateDetailModel({
    required this.id,
    required this.fullName,
    required this.doctorName,
    required this.certificateType,
    required this.purpose,
    required this.status,
    required this.gender,
    required this.bloodGroup,
    required this.medicalConditions,
    required this.medications,
    required this.notes,
    required this.createdAt,

    this.dob,
    this.certificateId,
    this.certificateFile,
    this.issuedAt,
    this.expiryDate,
  });

  factory PatientCertificateDetailModel.fromJson(Map<String, dynamic> json) {
    return PatientCertificateDetailModel(
      id: json["id"],

      fullName: json["full_name"] ?? "",

      doctorName: json["doctor_name"] ?? "",

      certificateType: json["certificate_type"] ?? "",

      purpose: json["purpose"] ?? "",

      status: json["status"] ?? "",

      gender: json["gender"] ?? "",

      bloodGroup: json["blood_group"] ?? "",

      medicalConditions: json["medical_conditions"] ?? "",

      medications: json["medications"] ?? "",

      notes: json["notes"] ?? "",

      createdAt: DateTime.parse(json["created_at"]),

      dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),

      certificateId: json["certificate_id"],

      certificateFile: json["certificate_file"],

      issuedAt: json["issued_at"] == null
          ? null
          : DateTime.parse(json["issued_at"]),

      expiryDate: json["expiry_date"] == null
          ? null
          : DateTime.parse(json["expiry_date"]),
    );
  }
}
