import 'package:flutter/material.dart';

class LabCategory {
  final String id;
  final String name;
  final IconData icon;

  const LabCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class LabPackage {
  final String id;
  final String title;
  final String subtitle;
  final double originalPrice;
  final double currentPrice;
  final int discountPercentage;
  final int parametersCount;
  final String reportDuration;
  final bool homeSampleAvailable;
  final String categoryId;

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
  });
}