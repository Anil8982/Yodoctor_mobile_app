class LabCategoryModel {
  final int id;
  final String name;

  const LabCategoryModel({required this.id, required this.name});

  factory LabCategoryModel.fromJson(Map<String, dynamic> json) {
    return LabCategoryModel(id: json["id"], name: json["name"] ?? "");
  }
}
