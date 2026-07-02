import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/dummy_data.dart';
import '../../../../core/models/medical_certificate.dart';

class CertificateState {
  final List<MedicalCertificate> allCertificates;
  final int activeTabIndex;
  final String searchQuery;
  final String selectedStatusFilter;
  final String selectedTypeFilter;

  CertificateState({
    required this.allCertificates,
    this.activeTabIndex = 0,
    this.searchQuery = '',
    this.selectedStatusFilter = 'All Status',
    this.selectedTypeFilter = 'All Types',
  });

  CertificateState copyWith({
    List<MedicalCertificate>? allCertificates,
    int? activeTabIndex,
    String? searchQuery,
    String? selectedStatusFilter,
    String? selectedTypeFilter,
  }) {
    return CertificateState(
      allCertificates: allCertificates ?? this.allCertificates,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      selectedTypeFilter: selectedTypeFilter ?? this.selectedTypeFilter,
    );
  }
}

class DoctorCertificateNotifier extends Notifier<CertificateState> {
  @override
  CertificateState build() {
    return CertificateState(
      allCertificates: List.from(DummyData.dummyCertificates),
    );
  }

  int get pendingCount => state.allCertificates.where((c) => c.status.toUpperCase() == 'PENDING' || c.status.toUpperCase() == 'VERIFICATION').length;
  int get totalCount => state.allCertificates.length;
  int get totalIssuedCount => state.allCertificates.where((c) => c.status.toUpperCase() == 'APPROVED').length;
  int get thisMonthIssuedCount => state.allCertificates.where((c) => c.status.toUpperCase() == 'APPROVED' && c.requestDate.month == DateTime.now().month).length;

  void setTabIndex(int index) {
    state = state.copyWith(
      activeTabIndex: index,
      selectedStatusFilter: 'All Status',
      selectedTypeFilter: 'All Types',
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.trim().toLowerCase());
  }

  void updateStatusFilter(String status) {
    state = state.copyWith(selectedStatusFilter: status);
  }

  void updateTypeFilter(String type) {
    state = state.copyWith(selectedTypeFilter: type);
  }

  List<MedicalCertificate> get filteredCertificates {
    final isIssuedTab = state.activeTabIndex == 1;

    return state.allCertificates.where((cert) {
      final matchesTab = isIssuedTab
          ? cert.status.toUpperCase() == 'APPROVED'
          : cert.status.toUpperCase() != 'APPROVED';

      final matchesStatus = state.selectedStatusFilter == 'All Status' ||
          cert.status.toLowerCase() == state.selectedStatusFilter.toLowerCase();

      final matchesType = state.selectedTypeFilter == 'All Types' ||
          cert.type.toLowerCase() == state.selectedTypeFilter.toLowerCase();

      final matchesSearch = state.searchQuery.isEmpty ||
          cert.patientName.toLowerCase().contains(state.searchQuery) ||
          cert.id.toLowerCase().contains(state.searchQuery);

      return matchesTab && matchesStatus && matchesType && matchesSearch;
    }).toList();
  }

  void approveCertificate(String id) {
    state = state.copyWith(
      allCertificates: state.allCertificates.map((c) {
        return c.id == id ? c.copyWith(status: 'APPROVED', issuedDate: DateTime.now()) : c;
      }).toList(),
    );
  }

  void rejectCertificate(String id) {
    state = state.copyWith(
      allCertificates: state.allCertificates.map((c) {
        return c.id == id ? c.copyWith(status: 'REJECTED') : c;
      }).toList(),
    );
  }
}

final doctorCertificateProvider = NotifierProvider.autoDispose<DoctorCertificateNotifier, CertificateState>(
  DoctorCertificateNotifier.new,
);