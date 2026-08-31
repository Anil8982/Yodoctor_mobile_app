class LabTestDetailModel {
  final int id;
  final String name;
  final String tagline;
  final double price;
  final double offerPrice;
  final String reportTime;
  final String type;
  final String tier;
  final int categoryId;
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
    required this.categoryId,
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
      categoryId: json["category_id"] is int
          ? json["category_id"]
          : int.tryParse(json["category_id"]?.toString() ?? "0") ?? 0,
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
