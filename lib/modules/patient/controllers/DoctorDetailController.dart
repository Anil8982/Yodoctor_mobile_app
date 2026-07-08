import 'package:flutter/material.dart';

import '../../../services/patient_search_service.dart';
import '../models/search/doctor_detail_model.dart';

class DoctorDetailController extends ChangeNotifier {
  final PatientSearchService _service = PatientSearchService();

  bool _isLoading = false;
  String? _errorMessage;

  DoctorDetailModel? _doctor;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  DoctorDetailModel? get doctor => _doctor;

  Future<void> loadDoctor(int doctorId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final response = await _service.getDoctorById(doctorId);

      if (response.statusCode == 200 && response.data["success"] == true) {
        _doctor = DoctorDetailModel.fromJson(response.data["doctor"]);
      } else {
        _errorMessage = response.data["message"];
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<DoctorDetailModel?> getDoctor(int doctorId) async {
    try {
      final response = await _service.getDoctorById(doctorId);
      print("STATUS = ${response.statusCode}");
      print("DATA = ${response.data}");
      if (response.statusCode == 200 && response.data["success"] == true) {
        return DoctorDetailModel.fromJson(response.data["doctor"]);
      }
    } catch (_) {}

    return null;
  }
}
