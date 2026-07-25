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
  final String id,
      title,
      name,
      slug,
      description,
      icon,
      category,
      currency,
      freeText,
      subtitle,
      durationText,
      buttonText,
      discountPercentage,
      gradient,
      circleColor;
  final double months, originalPrice, currentPrice, totalPrice, monthlyPrice;
  final double? yearlyPrice;
  final bool recommended, isBestValue;
  final List<PlanFeature> features;
  final PlanLimits? limits;

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
    this.yearlyPrice,
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
    return AvailablePlan(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      category: json['category'] ?? 'monthly',
      months: double.tryParse((json['months'] ?? 1).toString()) ?? 1.0,
      originalPrice:
          double.tryParse(
            (json['originalPrice'] ?? json['price'] ?? 0).toString(),
          ) ??
          0.0,
      currentPrice:
          double.tryParse(
            (json['price'] ?? json['totalPrice'] ?? 0).toString(),
          ) ??
          0.0,
      totalPrice:
          double.tryParse(
            (json['totalPrice'] ?? json['price'] ?? 0).toString(),
          ) ??
          0.0,
      monthlyPrice:
          double.tryParse(
            (json['monthlyPrice'] ?? json['price'] ?? 0).toString(),
          ) ??
          0.0,
      yearlyPrice: double.tryParse(
        (json['yearlyPrice'] ?? json['yearlyTotal'] ?? '').toString(),
      ),
      currency: json['currency'] ?? 'INR',
      recommended: json['recommended'] ?? false,
      freeText: json['freeText'] ?? '',
      subtitle: json['subtitle'] ?? '',
      durationText: json['subtitle'] ?? json['category'] ?? '',
      buttonText: json['buttonText'] ?? 'Choose Plan',
      discountPercentage: json['discount'] ?? '',
      gradient: json['gradient'] ?? '',
      circleColor: json['circleColor'] ?? '',
      features: (json['features'] as List? ?? [])
          .map((e) => PlanFeature.fromJson(e))
          .toList(),
      limits: json['limits'] != null
          ? PlanLimits.fromJson(json['limits'])
          : null,
      isBestValue: json['recommended'] ?? false,
    );
  }
}
