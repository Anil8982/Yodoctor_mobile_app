class DoctorCertificateDetailModel {
  final int id;
  final int? userId;
  final int? doctorId;
  final String fullName;
  final String certificateType;
  final String purpose;
  final String medicalConditions;
  final String gender;
  final String notes;
  final String medications;
  final String bloodGroup;
  final String status;
  final DateTime? dob;
  final double? height;
  final double? weight;
  final String? certificateId;
  final String? certificateFile;
  final DateTime? issuedAt;
  final DateTime? expiryDate;
  final String? qrCode;
  final String? doctorNotes;
  final String? fitnessStatus;

  const DoctorCertificateDetailModel({
    required this.id,
    this.userId,
    this.doctorId,
    required this.fullName,
    required this.certificateType,
    required this.purpose,
    required this.medicalConditions,
    required this.gender,
    required this.notes,
    required this.medications,
    this.bloodGroup = '',
    required this.status,
    this.dob,
    this.height,
    this.weight,
    this.certificateId,
    this.certificateFile,
    this.issuedAt,
    this.expiryDate,
    this.qrCode,
    this.doctorNotes,
    this.fitnessStatus,
  });

  factory DoctorCertificateDetailModel.fromJson(Map<String, dynamic> json) {
    return DoctorCertificateDetailModel(
      id: (json["id"] as num?)?.toInt() ?? 0,
      userId: (json["user_id"] as num?)?.toInt(),
      doctorId: (json["doctor_id"] as num?)?.toInt(),
      fullName: json["full_name"]?.toString() ?? "",
      certificateType: json["certificate_type"]?.toString() ?? "",
      purpose: json["purpose"]?.toString() ?? "",
      medicalConditions: json["medical_conditions"]?.toString() ?? "",
      gender: json["gender"]?.toString() ?? "",
      notes: json["notes"]?.toString() ?? "",
      medications: json["medications"]?.toString() ?? "",
      bloodGroup: json["blood_group"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
      dob: _parseDate(json["dob"]),
      height: _parseDouble(json["height"]),
      weight: _parseDouble(json["weight"]),
      certificateId: json["certificate_id"]?.toString(),
      certificateFile: json["certificate_file"]?.toString(),
      issuedAt: _parseDate(json["issued_at"]),
      expiryDate: _parseDate(json["expiry_date"]),
      qrCode: json["qr_code"]?.toString(),
      doctorNotes: json["doctor_notes"]?.toString(),
      fitnessStatus: json["fitness_status"]?.toString(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text);
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isRejected => status.toLowerCase() == 'rejected';
  bool get isFinalized => isApproved || isRejected;
  bool get isPending => status.toLowerCase() == 'verification';

  int get validityDays {
    if (issuedAt == null || expiryDate == null) return 30;
    final issued = DateTime(issuedAt!.year, issuedAt!.month, issuedAt!.day);
    final expiry = DateTime(expiryDate!.year, expiryDate!.month, expiryDate!.day);
    final days = expiry.difference(issued).inDays;
    return days > 0 ? days : 30;
  }

  String get initials {
    final name = fullName.trim();
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }

  String get formattedDob {
    if (dob == null) return 'N/A';
    return _formatDate(dob!);
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}