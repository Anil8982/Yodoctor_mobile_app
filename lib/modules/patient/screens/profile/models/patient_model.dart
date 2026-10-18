class PatientModel {
  final int id;
  final String fullName;
  final String phone;
  final String email;
  final String mobile;
  final String gender;
  final String dob;

  PatientModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.dob,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json["id"] ?? 0,
      fullName: json["fullName"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      mobile: json["mobile"] ?? "",
      gender: json["gender"] ?? "",
      dob: json["dob"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"fullName": fullName, "phone": phone, "gender": gender, "dob": dob};
  }
}
