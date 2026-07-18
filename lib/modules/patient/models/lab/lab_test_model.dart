import 'package:flutter/material.dart';

class LabCategory {
  final String id;
  final String name;
  final IconData icon;

  const LabCategory({required this.id, required this.name, required this.icon});
}

class LabPackage {
  final int id;

  final String title;

  final String subtitle;

  final double originalPrice;

  final double currentPrice;

  final int discountPercentage;

  final int parametersCount;

  final String reportDuration;

  final bool homeSampleAvailable;

  final String categoryId;

  final String type;

  final String tier;

  final String? image;

  const LabPackage({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.originalPrice,
    required this.currentPrice,
    required this.discountPercentage,
    required this.parametersCount,
    required this.reportDuration,
    required this.homeSampleAvailable,
    required this.categoryId,
    required this.type,
    required this.tier,
    this.image,
  });

  factory LabPackage.fromJson(Map<String, dynamic> json) {
    final original = (json["price"] ?? 0).toDouble();

    final offer = (json["offer_price"] ?? original).toDouble();

    final discount = original == 0
        ? 0
        : (((original - offer) / original) * 100).round();

    return LabPackage(
      id: json["id"],

      title: json["name"] ?? "",

      subtitle: json["tagline"] ?? "",

      originalPrice: original,

      currentPrice: offer,

      discountPercentage: discount,

      parametersCount: json["parameters_count"] ?? 0,

      reportDuration: json["report_time"] ?? "",

      homeSampleAvailable: (json["home_collection"] ?? 0) == 1,

      categoryId: (json["category_id"] ?? "").toString(),

      type: json["type"] ?? "",

      tier: json["tier"] ?? "",

      image: json["image"],
    );
  }
}
