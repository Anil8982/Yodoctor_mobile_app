class BookAppointmentRequest {
  final String doctorId;
  final String appointmentType;
  final String appointmentDate;
  final String slot;
  final List<int> familyMemberIds;

  BookAppointmentRequest({
    required this.doctorId,
    required this.appointmentType,
    required this.appointmentDate,
    required this.slot,
    required this.familyMemberIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "doctorId": doctorId,
      "appointmentType": appointmentType,
      "appointmentDate": appointmentDate,
      "slot": slot,
      "familyMemberIds": familyMemberIds,
    };
  }
}
