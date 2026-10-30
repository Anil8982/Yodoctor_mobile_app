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

  const EnquiryModel({
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

  EnquiryModel copyWith({
    int? id,
    String? name,
    String? mobile,
    String? email,
    String? concern,
    String? subConcern,
    String? message,
    String? status,
    String? date,
  }) {
    return EnquiryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      concern: concern ?? this.concern,
      subConcern: subConcern ?? this.subConcern,
      message: message ?? this.message,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}