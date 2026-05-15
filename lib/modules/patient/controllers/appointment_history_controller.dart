import 'package:flutter/foundation.dart';

import '../../../core/utils/dummy_data.dart';

class AppointmentHistoryController extends ChangeNotifier {
  AppointmentHistoryController() {
    loadHistory();
  }

  bool _isLoading = false;
  String? _errorMessage;
  List<AppointmentHistoryItem> _appointments = <AppointmentHistoryItem>[];

  final Map<String, int> _ratings = <String, int>{};
  final Map<String, String> _feedbacks = <String, String>{};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<AppointmentHistoryItem> get appointments =>
      List<AppointmentHistoryItem>.unmodifiable(_appointments);

  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _appointments = await DummyData.getAppointmentHistory();
    } catch (_) {
      _errorMessage = 'Unable to load appointment history. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int ratingFor(String appointmentId) => _ratings[appointmentId] ?? 0;

  String feedbackFor(String appointmentId) => _feedbacks[appointmentId] ?? '';

  Future<void> submitRating({
    required String appointmentId,
    required int rating,
    required String feedback,
  }) async {
    _ratings[appointmentId] = rating;
    _feedbacks[appointmentId] = feedback.trim();
    notifyListeners();
  }
}
