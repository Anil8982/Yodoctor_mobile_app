class PlaceNameModel {
  final String name;

  PlaceNameModel({required this.name});

  factory PlaceNameModel.fromJson(Map<String, dynamic> json) {
    return PlaceNameModel(name: json["name"] ?? "");
  }
}
