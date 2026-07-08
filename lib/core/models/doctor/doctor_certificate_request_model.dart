class DoctorCertificateRequestModel {
  final int id;
  final String fullName;
  final String certificateType;
  final String status;
  final DateTime createdAt;

  final String? certificateId;
  final DateTime? issuedAt;
  final DateTime? expiryDate;
  final String? certificateFile;
  final String? purpose;
  final String? doctorName;

  DoctorCertificateRequestModel({
    required this.id,
    required this.fullName,
    required this.certificateType,
    required this.status,
    required this.createdAt,
    this.certificateId,
    this.issuedAt,
    this.expiryDate,
    this.certificateFile,
    this.purpose,
    this.doctorName,
  });

  factory DoctorCertificateRequestModel.fromJson(Map<String, dynamic> json) {
    return DoctorCertificateRequestModel(
      id: json["id"],
      fullName: json["full_name"] ?? "",
      certificateType: json["certificate_type"] ?? "",
      status: json["status"] ?? "",
      createdAt: DateTime.parse(
        json["created_at"] ?? DateTime.now().toIso8601String(),
      ),
      certificateId: json["certificate_id"],
      issuedAt: json["issued_at"] != null
          ? DateTime.parse(json["issued_at"])
          : null,
      expiryDate: json["expiry_date"] != null
          ? DateTime.parse(json["expiry_date"])
          : null,
      certificateFile: json["certificate_file"],
      purpose: json["purpose"],
      doctorName: json["doctor_name"],
    );
  }
}
