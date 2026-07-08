class PatientModel {
  final String name;
  final String email;
  final String? image;

  PatientModel({required this.name, required this.email, this.image});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      image: json["image"],
    );
  }
}
