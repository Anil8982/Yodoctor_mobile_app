class BookAppointmentResponse {
  final int appointmentId;
  final int token;
  final String slot;

  BookAppointmentResponse({
    required this.appointmentId,
    required this.token,
    required this.slot,
  });

  factory BookAppointmentResponse.fromJson(Map<String, dynamic> json) {
    return BookAppointmentResponse(
      appointmentId: json["appointmentId"],
      token: json["token"],
      slot: json["slot"],
    );
  }
}
