class PlanFeature {
  final String text;
  final bool included;

  const PlanFeature({required this.text, required this.included});

  factory PlanFeature.fromJson(Map<String, dynamic> json) {
    return PlanFeature(
      text: json['text'] ?? '',
      included: json['included'] ?? false,
    );
  }
}

class PlanLimits {
  final int? maxUsers;
  final int? maxPatients;

  const PlanLimits({this.maxUsers, this.maxPatients});

  factory PlanLimits.fromJson(Map<String, dynamic> json) {
    return PlanLimits(
      maxUsers: json['maxUsers'],
      maxPatients: json['maxPatients'],
    );
  }
}

class AvailablePlan {
  final String id;
  final String title;
  final String name;
  final String slug;
  final String description;
  final String icon;
  final String category; // 'monthly' or 'yearly' (crucial for toggle filtering)
  final double months;
  final double originalPrice;
  final double currentPrice;
  final double totalPrice;
  final double monthlyPrice;
  final String currency;
  final bool recommended;
  final String freeText;
  final String subtitle;
  final String durationText; // Mapped from subtitle / category
  final String buttonText;
  final String discountPercentage;
  final String gradient;
  final String circleColor;
  final List<PlanFeature> features;
  final PlanLimits? limits;
  final bool isBestValue;

  const AvailablePlan({
    required this.id,
    required this.title,
    required this.name,
    required this.slug,
    required this.description,
    required this.icon,
    required this.category,
    required this.months,
    required this.originalPrice,
    required this.currentPrice,
    required this.totalPrice,
    required this.monthlyPrice,
    required this.currency,
    required this.recommended,
    required this.freeText,
    required this.subtitle,
    required this.durationText,
    required this.buttonText,
    required this.discountPercentage,
    required this.gradient,
    required this.circleColor,
    required this.features,
    this.limits,
    this.isBestValue = false,
  });

  factory AvailablePlan.fromJson(Map<String, dynamic> json) {
    final rawFeatures = json['features'] as List? ?? [];
    final parsedFeatures = rawFeatures
        .map((e) => PlanFeature.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return AvailablePlan(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      category: json['category'] ?? 'monthly',
      months: double.tryParse((json['months'] ?? 1).toString()) ?? 1.0,
      originalPrice: double.tryParse((json['originalPrice'] ?? json['price'] ?? 0).toString()) ?? 0.0,
      currentPrice: double.tryParse((json['price'] ?? json['totalPrice'] ?? 0).toString()) ?? 0.0,
      totalPrice: double.tryParse((json['totalPrice'] ?? json['price'] ?? 0).toString()) ?? 0.0,
      monthlyPrice: double.tryParse((json['monthlyPrice'] ?? json['price'] ?? 0).toString()) ?? 0.0,
      currency: json['currency'] ?? 'INR',
      recommended: json['recommended'] ?? false,
      freeText: json['freeText'] ?? '',
      subtitle: json['subtitle'] ?? '',
      durationText: json['subtitle'] ?? json['category'] ?? '',
      buttonText: json['buttonText'] ?? 'Choose Plan',
      discountPercentage: json['discount'] ?? '',
      gradient: json['gradient'] ?? '',
      circleColor: json['circleColor'] ?? '',
      features: parsedFeatures,
      limits: json['limits'] != null ? PlanLimits.fromJson(Map<String, dynamic>.from(json['limits'])) : null,
      isBestValue: json['recommended'] ?? false,
    );
  }

  AvailablePlan copyWith({
    String? id,
    String? title,
    String? name,
    String? slug,
    String? description,
    String? icon,
    String? category,
    double? months,
    double? originalPrice,
    double? currentPrice,
    double? totalPrice,
    double? monthlyPrice,
    String? currency,
    bool? recommended,
    String? freeText,
    String? subtitle,
    String? durationText,
    String? buttonText,
    String? discountPercentage,
    String? gradient,
    String? circleColor,
    List<PlanFeature>? features,
    PlanLimits? limits,
    bool? isBestValue,
  }) {
    return AvailablePlan(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      months: months ?? this.months,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      currency: currency ?? this.currency,
      recommended: recommended ?? this.recommended,
      freeText: freeText ?? this.freeText,
      subtitle: subtitle ?? this.subtitle,
      durationText: durationText ?? this.durationText,
      buttonText: buttonText ?? this.buttonText,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      gradient: gradient ?? this.gradient,
      circleColor: circleColor ?? this.circleColor,
      features: features ?? this.features,
      limits: limits ?? this.limits,
      isBestValue: isBestValue ?? this.isBestValue,
    );
  }
}