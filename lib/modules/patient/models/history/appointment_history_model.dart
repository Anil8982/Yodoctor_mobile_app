class AppointmentHistoryModel {
  final int id;
  final int doctorId;
  final String doctorName;
  final String specialization;
  final String? profileImage;
  final String appointmentDate;
  final String appointmentSlot;
  final int tokenNumber;
  final String status;
  final String patientName;
  final bool isFamily;
  final String createdBy;

  AppointmentHistoryModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    this.profileImage,
    required this.appointmentDate,
    required this.appointmentSlot,
    required this.tokenNumber,
    required this.status,
    required this.patientName,
    required this.isFamily,
    required this.createdBy,
  });

  factory AppointmentHistoryModel.fromJson(Map<String, dynamic> json) {
    return AppointmentHistoryModel(
      id: json["id"] ?? 0,
      doctorId: json["doctorId"] ?? 0,
      doctorName: json["doctorName"] ?? "",
      specialization: json["specialization"] ?? "",
      profileImage: json["profile_image"],
      appointmentDate: json["appointment_date"] ?? "",
      appointmentSlot: json["appointment_slot"] ?? "",
      tokenNumber: json["token_number"] ?? 0,
      status: json["status"] ?? "",
      patientName: json["patientName"] ?? "",
      isFamily: (json["isFamily"] ?? 0) == 1,
      createdBy: json["created_by"] ?? "",
    );
  }
}
