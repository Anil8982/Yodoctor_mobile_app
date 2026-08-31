class CityModel {
  final String city;
  final String address;
  final String landmark;
  final String type;
  final String label;

  CityModel({
    required this.city,
    required this.address,
    required this.landmark,
    required this.type,
    required this.label,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      city: json["city"] ?? "",
      address: json["address"] ?? "",
      landmark: json["landmark"] ?? "",
      type: json["type"] ?? "",
      label: json["label"] ?? "",
    );
  }
}
