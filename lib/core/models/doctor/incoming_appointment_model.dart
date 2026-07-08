class IncomingAppointmentModel {
  final String id;
  final String patientName;
  final String appointmentDate;
  final String appointmentSlot;
  final String tokenNumber;
  final String status;
  final String? profileImage;

  IncomingAppointmentModel({
    required this.id,
    required this.patientName,
    required this.appointmentDate,
    required this.appointmentSlot,
    required this.tokenNumber,
    required this.status,
    this.profileImage,
  });

  factory IncomingAppointmentModel.fromJson(Map<String, dynamic> json) {
    return IncomingAppointmentModel(
      id: json["id"].toString(),
      patientName:
          json["patientName"] ??
          json["familyMemberName"] ??
          json["walk_in_patient_name"] ??
          "",
      appointmentDate: json["appointment_date"] ?? "",
      appointmentSlot: json["appointment_slot"] ?? "",
      tokenNumber: json["token_number"].toString(),
      status: json["status"] ?? "",
      profileImage: json["profile_image"],
    );
  }
}
