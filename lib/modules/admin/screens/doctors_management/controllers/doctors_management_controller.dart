import 'package:flutter/material.dart';
import 'package:yodoctor/core/models/doctor_profile.dart';
import 'package:yodoctor/core/utils/dummy_data.dart';

class DoctorsManagementController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<DoctorProfile> _allDoctors = [];
  List<DoctorProfile> _doctors = [];

  String _searchQuery = '';
  String _selectedFilter = 'All';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<DoctorProfile> get doctors => _doctors;

  String get selectedFilter => _selectedFilter;

  DoctorsManagementController() {
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _allDoctors = List<DoctorProfile>.from(DummyData.allDoctors);

      _applyFilters();
    } catch (e) {
      _errorMessage = 'Failed to load doctors. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshDoctors() async {
    await loadDoctors();
  }

  void searchDoctors(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilters();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
  }

  void deleteDoctor(String doctorId) {
    try {
      _allDoctors.removeWhere((doctor) => doctor.id == doctorId);
      _applyFilters();
    } catch (e) {
      _errorMessage = 'Failed to delete doctor.';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _applyFilters() {
    _doctors = _allDoctors.where((doctor) {
      final matchesSearch =
          doctor.name.toLowerCase().contains(_searchQuery) ||
          doctor.specialty.toLowerCase().contains(_searchQuery) ||
          doctor.location.toLowerCase().contains(_searchQuery) ||
          doctor.hospital.toLowerCase().contains(_searchQuery);

      final matchesFilter =
          _selectedFilter == 'All' ||
          doctor.availableSlot.toLowerCase() == _selectedFilter.toLowerCase();

      return matchesSearch && matchesFilter;
    }).toList();

    notifyListeners();
  }

  //=========================
  // Dashboard Statistics
  //=========================

  int get totalDoctors => _allDoctors.length;

  int get totalSpecialities =>
      _allDoctors.map((e) => e.specialty).toSet().length;

  double get averageRating {
    if (_allDoctors.isEmpty) return 0;

    final total = _allDoctors.fold<double>(
      0,
      (sum, doctor) => sum + doctor.rating,
    );

    return total / _allDoctors.length;
  }

  int get totalReviews =>
      _allDoctors.fold<int>(
        0,
        (sum, doctor) => sum + doctor.reviewCount,
      );
}