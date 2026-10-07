import 'city_model.dart';
import 'doctor_name_model.dart';

class SuggestionModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  const SuggestionModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.metadata,
  });

  factory SuggestionModel.fromDoctorName(DoctorNameModel model) {
    return SuggestionModel(
      id: model.name.hashCode.toString(),
      title: model.name,
    );
  }

  factory SuggestionModel.fromClinicName(DoctorNameModel model) {
    return SuggestionModel(
      id: model.name.hashCode.toString(),
      title: model.name,
      subtitle: 'Clinic',
    );
  }

  factory SuggestionModel.fromCity(CityModel model) {
    return SuggestionModel(
      id: model.city.hashCode.toString(),
      title: model.city,
      subtitle: model.label,
    );
  }

  factory SuggestionModel.custom({
    required String id,
    required String title,
    String? subtitle,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return SuggestionModel(
      id: id,
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
      metadata: metadata,
    );
  }

  @override
  String toString() => 'SuggestionModel(title: $title, subtitle: $subtitle)';
}