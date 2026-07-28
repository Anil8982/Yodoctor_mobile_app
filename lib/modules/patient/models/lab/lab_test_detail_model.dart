class LabTestDetailModel {
  final int id;
  final String name;
  final String tagline;
  final double price;
  final double offerPrice;
  final String reportTime;
  final String type;
  final String tier;
  final String? image;
  final List<String> includes;

  const LabTestDetailModel({
    required this.id,
    required this.name,
    required this.tagline,
    required this.price,
    required this.offerPrice,
    required this.reportTime,
    required this.type,
    required this.tier,
    this.image,
    required this.includes,
  });

  factory LabTestDetailModel.fromJson(Map<String, dynamic> json) {
    return LabTestDetailModel(
      id: json["id"],
      name: json["name"] ?? "",
      tagline: json["tagline"] ?? "",
      price: double.tryParse(json["mrp"].toString()) ?? 0.0,
      offerPrice: double.tryParse(json["price"].toString()) ?? 0.0,
      reportTime: json["report_time"] ?? "",
      type: json["type"] ?? "",
      tier: json["tier"] ?? "",
      image: json["image"],
      includes:
          (json["includes"] as List?)
              ?.map((e) => e["include_name"].toString())
              .toList() ??
          [],
    );
  }
}
