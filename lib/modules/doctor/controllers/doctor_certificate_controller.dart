import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/doctor/doctor_certificate_request_model.dart';
import '../../../services/doctor_certificate_service.dart';

class CertificateState {
  final bool loading;

  final List<DoctorCertificateRequestModel> pendingCertificates;
  final List<DoctorCertificateRequestModel> issuedCertificates;

  final int activeTabIndex;
  final String searchQuery;
  final String selectedStatusFilter;
  final String selectedTypeFilter;

  const CertificateState({
    this.loading = false,
    this.pendingCertificates = const [],
    this.issuedCertificates = const [],
    this.activeTabIndex = 0,
    this.searchQuery = '',
    this.selectedStatusFilter = 'All Status',
    this.selectedTypeFilter = 'All Types',
  });

  CertificateState copyWith({
    bool? loading,
    List<DoctorCertificateRequestModel>? pendingCertificates,
    List<DoctorCertificateRequestModel>? issuedCertificates,
    int? activeTabIndex,
    String? searchQuery,
    String? selectedStatusFilter,
    String? selectedTypeFilter,
  }) {
    return CertificateState(
      loading: loading ?? this.loading,
      pendingCertificates: pendingCertificates ?? this.pendingCertificates,
      issuedCertificates: issuedCertificates ?? this.issuedCertificates,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      selectedTypeFilter: selectedTypeFilter ?? this.selectedTypeFilter,
    );
  }
}

class DoctorCertificateNotifier extends Notifier<CertificateState> {
  final DoctorCertificateService _service = DoctorCertificateService();

  @override
  CertificateState build() {
    Future.microtask(() async {
      await loadRequests();
      await loadIssuedCertificates();
    });

    return const CertificateState();
  }

  Future<void> loadRequests() async {
    state = state.copyWith(loading: true);

    try {
      final response = await _service.getRequests();

      final list = (response.data as List)
          .map((e) => DoctorCertificateRequestModel.fromJson(e))
          .toList();

      state = state.copyWith(loading: false, pendingCertificates: list);
    } catch (_) {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> loadIssuedCertificates() async {
    try {
      final response = await _service.getIssuedCertificates();

      final list = (response.data as List)
          .map((e) => DoctorCertificateRequestModel.fromJson(e))
          .toList();

      state = state.copyWith(issuedCertificates: list);
    } catch (_) {}
  }

  int get pendingCount => state.pendingCertificates.length;

  int get issuedCount => state.issuedCertificates.length;

  int get totalCount => pendingCount + issuedCount;

  void setTabIndex(int index) {
    state = state.copyWith(
      activeTabIndex: index,
      selectedStatusFilter: "All Status",
      selectedTypeFilter: "All Types",
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

  List<DoctorCertificateRequestModel> get filteredCertificates {
    final source = state.activeTabIndex == 0
        ? state.pendingCertificates
        : state.issuedCertificates;

    return source.where((cert) {
      final matchesStatus =
          state.selectedStatusFilter == "All Status" ||
          cert.status.toLowerCase() == state.selectedStatusFilter.toLowerCase();

      final matchesType =
          state.selectedTypeFilter == "All Types" ||
          cert.certificateType.toLowerCase() ==
              state.selectedTypeFilter.toLowerCase();

      final matchesSearch =
          state.searchQuery.isEmpty ||
          cert.fullName.toLowerCase().contains(state.searchQuery) ||
          cert.id.toString().contains(state.searchQuery);

      return matchesStatus && matchesType && matchesSearch;
    }).toList();
  }

  Future<void> approveCertificate({
    required int id,
    required String notes,
    required String fitnessStatus,
    required int validity,
  }) async {
    await _service.approve(
      id: id,
      doctorNotes: notes,
      fitnessStatus: fitnessStatus,
      validity: validity,
    );

    await loadRequests();
    await loadIssuedCertificates();
  }

  Future<void> rejectCertificate(int id) async {
    await _service.reject(id);

    await loadRequests();
  }

  Future<void> refresh() async {
    await loadRequests();
    await loadIssuedCertificates();
  }
}

final doctorCertificateProvider =
    NotifierProvider<DoctorCertificateNotifier, CertificateState>(
      DoctorCertificateNotifier.new,
    );
