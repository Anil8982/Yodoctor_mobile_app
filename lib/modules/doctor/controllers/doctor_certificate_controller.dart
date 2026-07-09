import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../core/models/doctor/doctor_certificate_request_model.dart';
import '../repositories/doctor_certificate_repository.dart';

class CertificateState {
  final bool loading;
  final List<DoctorCertificateRequestModel> pendingCertificates;
  final List<DoctorCertificateRequestModel> issuedCertificates;
  final int activeTabIndex;
  final String searchQuery;
  final String selectedStatusFilter;
  final String selectedTypeFilter;
  final String? errorMessage;

  const CertificateState({
    this.loading = false,
    this.pendingCertificates = const [],
    this.issuedCertificates = const [],
    this.activeTabIndex = 0,
    this.searchQuery = '',
    this.selectedStatusFilter = 'All Status',
    this.selectedTypeFilter = 'All Types',
    this.errorMessage,
  });

  CertificateState copyWith({
    bool? loading,
    List<DoctorCertificateRequestModel>? pendingCertificates,
    List<DoctorCertificateRequestModel>? issuedCertificates,
    int? activeTabIndex,
    String? searchQuery,
    String? selectedStatusFilter,
    String? selectedTypeFilter,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CertificateState(
      loading: loading ?? this.loading,
      pendingCertificates: pendingCertificates ?? this.pendingCertificates,
      issuedCertificates: issuedCertificates ?? this.issuedCertificates,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      selectedTypeFilter: selectedTypeFilter ?? this.selectedTypeFilter,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final doctorCertificateProvider =
NotifierProvider<DoctorCertificateNotifier, CertificateState>(
  DoctorCertificateNotifier.new,
);

class DoctorCertificateNotifier extends Notifier<CertificateState> {
  static const String _subTag = 'DoctorCertificateNotifier';

  @override
  CertificateState build() {
    AppLogger.info('DoctorCertificateNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);
    Future.microtask(refresh);
    return const CertificateState();
  }

  Future<void> loadRequests() async {
    state = state.copyWith(loading: true, clearError: true);
    AppLogger.info('Fetching pending certificate requests...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.getRequests();
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300 && response.data["success"] == true) {
        final rawList = response.data["data"] as List? ?? [];
        final list = rawList.map((e) => DoctorCertificateRequestModel.fromJson(e)).toList();

        AppLogger.success('Pending requests fetched successfully. Count: ${list.length}', tag: LogTags.doctor, subTag: _subTag);
        state = state.copyWith(loading: false, pendingCertificates: list);
      } else {
        final msg = response.data["message"] ?? "Failed to load requests";
        AppLogger.warning('Failed to load pending requests: $msg', tag: LogTags.doctor, subTag: _subTag);
        state = state.copyWith(loading: false, errorMessage: msg);
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to load requests");
      AppLogger.exception(e, st, message: 'Load requests execution failure', tag: LogTags.doctor, subTag: _subTag);
    }
  }

  Future<void> loadIssuedCertificates() async {
    state = state.copyWith(loading: true, clearError: true);
    AppLogger.info('Fetching issued certificates...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.getIssuedCertificates();
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300 && response.data["success"] == true) {
        final rawList = response.data["data"] as List? ?? [];
        final list = rawList.map((e) => DoctorCertificateRequestModel.fromJson(e)).toList();

        AppLogger.success('Issued certificates fetched successfully. Count: ${list.length}', tag: LogTags.doctor, subTag: _subTag);
        state = state.copyWith(loading: false, issuedCertificates: list);
      } else {
        final msg = response.data["message"] ?? "Failed to load issued certs";
        AppLogger.warning('Failed to load issued certificates: $msg', tag: LogTags.doctor, subTag: _subTag);
        state = state.copyWith(loading: false, errorMessage: msg);
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to load issued certs");
      AppLogger.exception(e, st, message: 'Load issued certificates exception', tag: LogTags.doctor, subTag: _subTag);
    }
  }

  int get pendingCount => state.pendingCertificates.length;
  int get issuedCount => state.issuedCertificates.length;
  int get totalCount => pendingCount + issuedCount;

  void setTabIndex(int index) {
    AppLogger.info('Switching to tab index: $index', tag: LogTags.doctor, subTag: _subTag);
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
    AppLogger.info('Filter change -> Status: $status', tag: LogTags.doctor, subTag: _subTag);
    state = state.copyWith(selectedStatusFilter: status);
  }

  void updateTypeFilter(String type) {
    AppLogger.info('Filter change -> Type: $type', tag: LogTags.doctor, subTag: _subTag);
    state = state.copyWith(selectedTypeFilter: type);
  }

  List<DoctorCertificateRequestModel> get filteredCertificates {
    final source = state.activeTabIndex == 0
        ? state.pendingCertificates
        : state.issuedCertificates;

    final filtered = source.where((cert) {
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

    return filtered;
  }

  Future<bool> approveCertificate({
    required int id,
    required String notes,
    required String fitnessStatus,
    required int validity,
  }) async {
    final payload = {
      "id": id,
      "doctorNotes": notes,
      "fitnessStatus": fitnessStatus,
      "validity": validity,
    };

    AppLogger.info('Approving certificate ID: $id', tag: LogTags.doctor, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.doctor, subTag: '$_subTag/ApprovePayload');

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.approve(
        id: id,
        doctorNotes: notes,
        fitnessStatus: fitnessStatus,
        validity: validity,
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300 && response.data["success"] == true) {
        AppLogger.success('Certificate ID: $id approved successfully', tag: LogTags.doctor, subTag: _subTag);
        await refresh();
        return true;
      }
      AppLogger.warning('Certificate approval rejected by backend for ID: $id', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Approve certificate faulted', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }

  Future<bool> rejectCertificate(int id) async {
    AppLogger.info('Rejecting certificate ID: $id', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.reject(id);

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300 && response.data["success"] == true) {
        AppLogger.success('Certificate ID: $id rejected successfully', tag: LogTags.doctor, subTag: _subTag);
        await loadRequests();
        return true;
      }
      AppLogger.warning('Certificate rejection failed on backend for ID: $id', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      AppLogger.exception(e, st, message: 'Reject certificate faulted', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }

  Future<void> refresh() async {
    if (state.loading) return;
    state = state.copyWith(loading: true, clearError: true);
    AppLogger.info('Executing global certificate pipeline sync...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final reqResponse = await repository.getRequests();
      final issuedResponse = await repository.getIssuedCertificates();

      List<DoctorCertificateRequestModel> pendingList = state.pendingCertificates;
      List<DoctorCertificateRequestModel> issuedList = state.issuedCertificates;

      if (reqResponse.statusCode != null && reqResponse.statusCode! >= 200 && reqResponse.statusCode! < 300) {
        final rawList = reqResponse.data["data"] as List? ?? [];
        pendingList = rawList.map((e) => DoctorCertificateRequestModel.fromJson(e)).toList();
      }

      if (issuedResponse.statusCode != null && issuedResponse.statusCode! >= 200 && issuedResponse.statusCode! < 300) {
        final rawList = issuedResponse.data["data"] as List? ?? [];
        issuedList = rawList.map((e) => DoctorCertificateRequestModel.fromJson(e)).toList();
      }

      AppLogger.success('Global certificate sync complete. Pending: ${pendingList.length}, Issued: ${issuedList.length}', tag: LogTags.doctor, subTag: _subTag);

      state = state.copyWith(
        loading: false,
        pendingCertificates: pendingList,
        issuedCertificates: issuedList,
      );
    } catch (e, st) {
      state = state.copyWith(loading: false);
      AppLogger.exception(e, st, message: 'Global synchronization pipeline crash', tag: LogTags.doctor, subTag: _subTag);
    }
  }
}