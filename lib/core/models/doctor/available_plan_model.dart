class AvailablePlan {
  final String id;
  final String title;
  final double originalPrice;
  final double currentPrice;
  final String durationText;
  final String description;
  final String badgeText;
  final String discountPercentage;
  final bool isBestValue;

  const AvailablePlan({
    required this.id,
    required this.title,
    required this.originalPrice,
    required this.currentPrice,
    required this.durationText,
    required this.description,
    required this.badgeText,
    required this.discountPercentage,
    this.isBestValue = false,
  });

  factory AvailablePlan.fromJson(Map<String, dynamic> json) {
    return AvailablePlan(
      id: json['id'] as String,
      title: json['title'] as String,
      originalPrice: (json['original_price'] as num).toDouble(),
      currentPrice: (json['current_price'] as num).toDouble(),
      durationText: json['duration_text'] as String,
      description: json['description'] as String,
      badgeText: json['badge_text'] as String,
      discountPercentage: json['discount_percentage'] as String,
      isBestValue: json['is_best_value'] as bool? ?? false,
    );
  }

  AvailablePlan copyWith({
    String? id,
    String? title,
    double? originalPrice,
    double? currentPrice,
    String? durationText,
    String? description,
    String? badgeText,
    String? discountPercentage,
    bool? isBestValue,
  }) {
    return AvailablePlan(
      id: id ?? this.id,
      title: title ?? this.title,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      durationText: durationText ?? this.durationText,
      description: description ?? this.description,
      badgeText: badgeText ?? this.badgeText,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      isBestValue: isBestValue ?? this.isBestValue,
    );
  }
}