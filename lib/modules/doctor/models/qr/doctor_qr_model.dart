class DoctorQrModel {
  final int doctorId;
  final String doctorName;
  final String specialization;
  final String qrUrl;

  const DoctorQrModel({
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.qrUrl,
  });

  factory DoctorQrModel.fromJson(Map<String, dynamic> json) {
    return DoctorQrModel(
      doctorId: int.tryParse(json["doctorId"].toString()) ?? 0,
      doctorName: json["doctorName"]?.toString() ?? "",
      specialization: json["specialization"]?.toString() ?? "",
      qrUrl: json["qrUrl"]?.toString() ?? "",
    );
  }
}
