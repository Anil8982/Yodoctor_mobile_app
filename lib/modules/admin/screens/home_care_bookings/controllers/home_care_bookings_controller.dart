import 'package:flutter/material.dart';
import 'package:yodoctor/modules/admin/screens/home_care_bookings/models/home_care_booking_model.dart';

class HomeCareBookingsController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<HomeCareBookingModel> _bookings = [];
  List<HomeCareBookingModel> _filteredBookings = [];

  /// Stores deleted booking ids
  final Set<int> _deletedIds = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<HomeCareBookingModel> get bookings => _filteredBookings;

  HomeCareBookingsController() {
    loadBookings();
  }

  Future<void> loadBookings() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final allBookings = [
      HomeCareBookingModel(
        id: 1,
        patientName: "Ajay Singh",
        contact: "7879518155",
        address: "Bhopal",
        healthIssue: "I am suffering from fever",
        service: "Nurse",
        date: "13/06/2026",
        days: "1 day",
        time: "Evening",
      ),
      HomeCareBookingModel(
        id: 2,
        patientName: "Chandan Kumar",
        contact: "6261715701",
        address: "Jhansi",
        healthIssue: "Bukhar he",
        service: "Nurse",
        date: "29/05/2026",
        days: "1 day",
        time: "Evening",
      ),
      HomeCareBookingModel(
        id: 3,
        patientName: "Sabita Kumari",
        contact: "6260708470",
        address: "Jhansi",
        healthIssue: "General Medicine",
        service: "Nurse",
        date: "16/05/2026",
        days: "1 day",
        time: "Afternoon",
      ),
    ];

    /// Remove deleted bookings
    _bookings = allBookings
        .where((booking) => !_deletedIds.contains(booking.id))
        .toList();

    _applySearch();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshBookings() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final allBookings = [
      HomeCareBookingModel(
        id: 1,
        patientName: "Ajay Singh",
        contact: "7879518155",
        address: "Bhopal",
        healthIssue: "I am suffering from fever",
        service: "Nurse",
        date: "13/06/2026",
        days: "1 day",
        time: "Evening",
      ),
      HomeCareBookingModel(
        id: 2,
        patientName: "Chandan Kumar",
        contact: "6261715701",
        address: "Jhansi",
        healthIssue: "Bukhar he",
        service: "Nurse",
        date: "29/05/2026",
        days: "1 day",
        time: "Evening",
      ),
      HomeCareBookingModel(
        id: 3,
        patientName: "Sabita Kumari",
        contact: "6260708470",
        address: "Jhansi",
        healthIssue: "General Medicine",
        service: "Nurse",
        date: "16/05/2026",
        days: "1 day",
        time: "Afternoon",
      ),
    ];

    _bookings = allBookings
        .where((booking) => !_deletedIds.contains(booking.id))
        .toList();

    _applySearch();

    notifyListeners();
  }

  void deleteBooking(int id) {
    _deletedIds.add(id);

    _bookings.removeWhere((booking) => booking.id == id);

    _applySearch();

    notifyListeners();
  }

  void searchBookings(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.trim().isEmpty) {
      _filteredBookings = List.from(_bookings);
      return;
    }

    final search = _searchQuery.toLowerCase();

    _filteredBookings = _bookings.where((booking) {
      return booking.patientName.toLowerCase().contains(search) ||
          booking.service.toLowerCase().contains(search);
    }).toList();
  }

  int get totalBookings => _bookings.length;

  int get totalServices =>
      _bookings.map((e) => e.service).toSet().length;

  int get thisWeekBookings => _bookings.length > 1 ? 1 : 0;
}