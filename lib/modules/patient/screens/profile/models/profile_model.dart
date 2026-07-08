import '../models/patient_model.dart';

class ProfileModel {
  final bool success;
  final PatientModel data;

  ProfileModel({required this.success, required this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      success: json["success"] ?? false,
      data: PatientModel.fromJson(json["data"] ?? {}),
    );
  }
}
