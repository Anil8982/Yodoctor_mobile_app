class SpecialtyModel {
  final String name;

  SpecialtyModel({required this.name});

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(name: json["name"] ?? "");
  }
}
