import 'package:flutter/foundation.dart';

import '../../../services/patient_appointment_history_service.dart';
import '../models/history/appointment_history_model.dart';

class AppointmentHistoryController extends ChangeNotifier {
  AppointmentHistoryController() {
    loadHistory();
  }

  final PatientAppointmentHistoryService _service =
      PatientAppointmentHistoryService();

  bool _isLoading = false;
  bool _isLoadingMore = false;

  String? _errorMessage;

  List<AppointmentHistoryModel> _appointments = [];

  String? _nextCursor;

  final Map<int, int> _ratings = {};
  final Map<int, String> _feedbacks = {};

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  String? get errorMessage => _errorMessage;

  List<AppointmentHistoryModel> get appointments => _appointments;

  bool get hasMore => _nextCursor != null;

  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getAppointmentHistory();

      if (response.statusCode == 200) {
        final data = response.data;

        _nextCursor = data["nextCursor"];

        _appointments = (data["data"] as List)
            .map((e) => AppointmentHistoryModel.fromJson(e))
            .toList();
      } else {
        _errorMessage = response.data["message"];
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || _nextCursor == null) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final response = await _service.getAppointmentHistory(
        cursor: _nextCursor,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        _nextCursor = data["nextCursor"];

        final List<AppointmentHistoryModel> more = (data["data"] as List)
            .map((e) => AppointmentHistoryModel.fromJson(e))
            .toList();

        _appointments.addAll(more);
      }
    } catch (_) {}

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _appointments.clear();
    _nextCursor = null;
    await loadHistory();
  }

  int ratingFor(int appointmentId) => _ratings[appointmentId] ?? 0;

  String feedbackFor(int appointmentId) => _feedbacks[appointmentId] ?? "";

  Future<void> submitRating({
    required int appointmentId,
    required int rating,
    required String feedback,
  }) async {
    try {
      final response = await _service.submitDoctorReview(
        appointmentId: appointmentId,
        rating: rating,
        comment: feedback,
      );

      if (response.statusCode == 200) {
        _ratings[appointmentId] = rating;
        _feedbacks[appointmentId] = feedback.trim();
        notifyListeners();
      } else {
        throw Exception(response.data["message"]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getPrescription(int appointmentId) async {
    final response = await _service.getPrescription(appointmentId);

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return Map<String, dynamic>.from(response.data);
    }

    throw Exception(response.data["message"] ?? "Prescription not found");
  }
}
