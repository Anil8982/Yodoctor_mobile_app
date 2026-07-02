class EnquiryModel {
  final int id;
  final String name;
  final String mobile;
  final String email;
  final String concern;
  final String subConcern;
  final String message;
  final String status;
  final String date;

  EnquiryModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.concern,
    required this.subConcern,
    required this.message,
    required this.status,
    required this.date,
  });
}