class HomeCareBookingModel {
  final int id;
  final String patientName;
  final String contact;
  final String address;
  final String healthIssue;
  final String service;
  final String date;
  final String days;
  final String time;

  HomeCareBookingModel({
    required this.id,
    required this.patientName,
    required this.contact,
    required this.address,
    required this.healthIssue,
    required this.service,
    required this.date,
    required this.days,
    required this.time,
  });
}