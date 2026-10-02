class PatientCertificateRequestModel {
  final int id;
  final String certificateType;
  final String purpose;
  final String status;
  final String doctorName;
  final String? certificateId;
  final String? certificateFile;
  final DateTime createdAt;
  final DateTime? issuedAt;
  final DateTime? expiryDate;

  const PatientCertificateRequestModel({
    required this.id,
    required this.certificateType,
    required this.purpose,
    required this.status,
    required this.doctorName,
    this.certificateId,
    this.certificateFile,
    required this.createdAt,
    this.issuedAt,
    this.expiryDate,
  });

  factory PatientCertificateRequestModel.fromJson(Map<String, dynamic> json) {
    return PatientCertificateRequestModel(
      id: json["id"],
      certificateType: json["certificate_type"] ?? "",
      purpose: json["purpose"] ?? "",
      status: json["status"] ?? "",
      doctorName: json["doctor_name"] ?? "",
      certificateId: json["certificate_id"],
      certificateFile: json["certificate_file"],
      createdAt: DateTime.parse(json["created_at"]),
      issuedAt: json["issued_at"] == null
          ? null
          : DateTime.parse(json["issued_at"]),
      expiryDate: json["expiry_date"] == null
          ? null
          : DateTime.parse(json["expiry_date"]),
    );
  }
}
