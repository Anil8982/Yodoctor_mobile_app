class CertificateServiceModel {
  final int? id;
  final int doctorId;
  final String service;
  final bool enabled;
  final double fee;
  final String? instructions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CertificateServiceModel({
    this.id,
    required this.doctorId,
    required this.service,
    required this.enabled,
    required this.fee,
    this.instructions,
    this.createdAt,
    this.updatedAt,
  });

  factory CertificateServiceModel.fromJson(Map<String, dynamic> json) {
    return CertificateServiceModel(
      id: json['id'] as int?,
      doctorId: json['doctor_id'] is num
          ? (json['doctor_id'] as num).toInt()
          : int.tryParse(json['doctor_id']?.toString() ?? '') ?? 0,
      service: json['service']?.toString() ?? 'CERTIFICATE',

      enabled: json['enabled'] == true ||
          json['enabled'] == 1 ||
          json['enabled']?.toString() == '1' ||
          json['enabled']?.toString().toLowerCase() == 'true',

      fee: double.tryParse(
        json['fee']?.toString() ?? '0',
      ) ??
          0.0,

      instructions: json['instructions']?.toString(),

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'service': service,
      'enabled': enabled,
      'fee': fee,
      'instructions': instructions,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CertificateServiceModel copyWith({
    int? id,
    int? doctorId,
    String? service,
    bool? enabled,
    double? fee,
    String? instructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CertificateServiceModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      service: service ?? this.service,
      enabled: enabled ?? this.enabled,
      fee: fee ?? this.fee,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}