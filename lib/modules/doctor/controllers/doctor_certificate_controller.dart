import 'package:flutter/material.dart';
import '../../../../core/utils/dummy_data.dart';

class DoctorCertificateController extends ChangeNotifier {
  final List<MedicalCertificate> _allCertificates = List.from(DummyData.dummyCertificates);

  int _activeTabIndex = 0;
  String _searchQuery = '';
  String _selectedStatusFilter = 'All Status';
  String _selectedTypeFilter = 'All Types';

  // Getters
  int get activeTabIndex => _activeTabIndex;
  String get selectedStatusFilter => _selectedStatusFilter;
  String get selectedTypeFilter => _selectedTypeFilter;

  int get pendingCount => _allCertificates.where((c) => c.status.toUpperCase() == 'PENDING' || c.status.toUpperCase() == 'VERIFICATION').length;
  int get totalCount => _allCertificates.length;
  int get totalIssuedCount => _allCertificates.where((c) => c.status.toUpperCase() == 'APPROVED').length;
  int get thisMonthIssuedCount => _allCertificates.where((c) => c.status.toUpperCase() == 'APPROVED' && c.requestDate.month == DateTime.now().month).length;

  void setTabIndex(int index) {
    _activeTabIndex = index;
    _selectedStatusFilter = 'All Status';
    _selectedTypeFilter = 'All Types';
    notifyListeners();
  }

  // सर्च क्वेरी अपडेट
  void updateSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  // स्टेटस फिल्टर बदलणे
  void updateStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  // सर्टिफिकेट टाईप फिल्टर बदलणे
  void updateTypeFilter(String type) {
    _selectedTypeFilter = type;
    notifyListeners();
  }

  List<MedicalCertificate> get filteredCertificates {
    final isIssuedTab = _activeTabIndex == 1;

    return _allCertificates.where((cert) {
      final matchesTab = isIssuedTab
          ? cert.status.toUpperCase() == 'APPROVED'
          : cert.status.toUpperCase() != 'APPROVED';

      final matchesStatus = _selectedStatusFilter == 'All Status' ||
          cert.status.toLowerCase() == _selectedStatusFilter.toLowerCase();

      final matchesType = _selectedTypeFilter == 'All Types' ||
          cert.type.toLowerCase() == _selectedTypeFilter.toLowerCase();

      final matchesSearch = _searchQuery.isEmpty ||
          cert.patientName.toLowerCase().contains(_searchQuery) ||
          cert.id.toLowerCase().contains(_searchQuery);

      return matchesTab && matchesStatus && matchesType && matchesSearch;
    }).toList();
  }

  void approveCertificate(String id) {
    final index = _allCertificates.indexWhere((c) => c.id == id);
    if (index != -1) {
      _allCertificates[index] = _allCertificates[index].copyWith(
        status: 'APPROVED',
        issuedDate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void rejectCertificate(String id) {
    final index = _allCertificates.indexWhere((c) => c.id == id);
    if (index != -1) {
      _allCertificates[index] = _allCertificates[index].copyWith(
        status: 'REJECTED',
      );
      notifyListeners();
    }
  }
}