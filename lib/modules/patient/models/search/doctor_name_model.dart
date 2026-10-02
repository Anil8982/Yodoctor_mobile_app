class DoctorNameModel {
  final String name;

  DoctorNameModel({required this.name});

  factory DoctorNameModel.fromJson(Map<String, dynamic> json) {
    return DoctorNameModel(name: json["name"] ?? "");
  }
}
