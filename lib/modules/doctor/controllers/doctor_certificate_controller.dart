import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_certificate_request_model.dart';
import '../repositories/doctor_certificate_repository.dart';

class CertificateState {
  final bool loading;
  final bool refreshing;
  final List<DoctorCertificateRequestModel> pendingCertificates;
  final List<DoctorCertificateRequestModel> issuedCertificates;
  final int activeTabIndex;
  final String searchQuery;
  final String selectedStatusFilter;
  final String selectedTypeFilter;
  final String? errorMessage;

  const CertificateState({
    this.loading = false,
    this.refreshing = false,
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
    bool? refreshing,
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
      refreshing: refreshing ?? this.refreshing,
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
    AppLogger.info(
      'DoctorCertificateNotifier Initialized',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    Future.microtask(refresh);
    return const CertificateState();
  }

  /// ✅ Safe list extractor that handles:
  /// - Direct JSON array: [...]
  /// - Wrapped object: {"success": true, "data": [...]}
  /// - Empty array: []
  /// - null / empty body
  /// - Unexpected structures (logs warning, returns empty list)
  List<dynamic> _extractList(dynamic data) {
    // Case 1: null or empty body
    if (data == null || data == '') {
      AppLogger.info(
        'Response data is null or empty, returning empty list',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return [];
    }

    // Case 2: Direct JSON array
    if (data is List) {
      AppLogger.info(
        'Extracted direct list with ${data.length} items',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return data;
    }

    // Case 3: Wrapped object with "data" field
    if (data is Map<String, dynamic>) {
      // Check for success flag if present, but don't require it
      final hasSuccess = data.containsKey('success');
      if (hasSuccess && data['success'] != true) {
        AppLogger.warning(
          'Response has success=false, but returning data anyway if present',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      }

      if (data.containsKey('data')) {
        final innerData = data['data'];
        if (innerData is List) {
          AppLogger.info(
            'Extracted wrapped list with ${innerData.length} items',
            tag: LogTags.doctor,
            subTag: _subTag,
          );
          return innerData;
        }
        if (innerData == null) {
          AppLogger.info(
            'Wrapped data is null, returning empty list',
            tag: LogTags.doctor,
            subTag: _subTag,
          );
          return [];
        }
        // Inner data exists but isn't a List - log and try to handle
        AppLogger.warning(
          'Wrapped data is not a List: ${innerData.runtimeType}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        return [];
      }

      // Wrapped object without "data" field - maybe it's a single item?
      // Check if it looks like a certificate object
      if (data.containsKey('id') && data.containsKey('full_name')) {
        AppLogger.info(
          'Response is a single object, wrapping in list',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        return [data];
      }
    }

    // Case 4: Unexpected structure
    AppLogger.warning(
      'Unexpected response structure: ${data.runtimeType}',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    return [];
  }

  /// ✅ Safe parser that converts raw list to models
  List<DoctorCertificateRequestModel> _parseCertificateList(
      dynamic data,
      String endpoint,
      ) {
    try {
      final rawList = _extractList(data);
      final models = rawList
          .map((item) {
        try {
          if (item is Map<String, dynamic>) {
            return DoctorCertificateRequestModel.fromJson(item);
          }
          // Try to convert if it's a Map-like but not typed
          final map = Map<String, dynamic>.from(item as Map);
          return DoctorCertificateRequestModel.fromJson(map);
        } catch (e) {
          AppLogger.warning(
            'Failed to parse individual certificate item: $e',
            tag: LogTags.doctor,
            subTag: _subTag,
          );
          return null;
        }
      })
          .whereType<DoctorCertificateRequestModel>()
          .toList();

      AppLogger.info(
        'Parsed ${models.length} certificates from $endpoint',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return models;
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Failed to parse certificate list from $endpoint',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return [];
    }
  }

  Future<void> loadRequests() async {
    state = state.copyWith(loading: true, clearError: true);
    AppLogger.info(
      'Fetching pending certificate requests...',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.getRequests();
      final statusCode = response.statusCode ?? 0;

      // ✅ HTTP 2xx = success, regardless of response structure
      if (statusCode >= 200 && statusCode < 300) {
        final list = _parseCertificateList(response.data, '/certificate/requests');

        AppLogger.success(
          'Pending requests fetched successfully. Count: ${list.length}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(loading: false, pendingCertificates: list);
      } else {
        final msg = response.data?['message'] ?? "Failed to load requests";
        AppLogger.warning(
          'Failed to load pending requests: $msg',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(loading: false, errorMessage: msg);
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to load requests");
      AppLogger.exception(
        e,
        st,
        message: 'Load requests execution failure',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  Future<void> loadIssuedCertificates() async {
    state = state.copyWith(loading: true, clearError: true);
    AppLogger.info(
      'Fetching issued certificates...',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.getIssuedCertificates();
      final statusCode = response.statusCode ?? 0;

      // ✅ HTTP 2xx = success, even with empty list
      if (statusCode >= 200 && statusCode < 300) {
        final list = _parseCertificateList(response.data, '/certificate/issued');

        AppLogger.success(
          'Issued certificates fetched successfully. Count: ${list.length}',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(loading: false, issuedCertificates: list);
      } else {
        final msg = response.data?['message'] ?? "Failed to load issued certs";
        AppLogger.warning(
          'Failed to load issued certificates: $msg',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(loading: false, errorMessage: msg);
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to load issued certs");
      AppLogger.exception(
        e,
        st,
        message: 'Load issued certificates exception',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }

  int get pendingCount => state.pendingCertificates.length;
  int get issuedCount => state.issuedCertificates.length;
  int get totalCount => pendingCount + issuedCount;

  void setTabIndex(int index) {
    AppLogger.info(
      'Switching to tab index: $index',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
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
    AppLogger.info(
      'Filter change -> Status: $status',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(selectedStatusFilter: status);
  }

  void updateTypeFilter(String type) {
    AppLogger.info(
      'Filter change -> Type: $type',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(selectedTypeFilter: type);
  }

  List<DoctorCertificateRequestModel> get filteredCertificates {
    final source = state.activeTabIndex == 0
        ? state.pendingCertificates
        : state.issuedCertificates;

    final filtered = source.where((cert) {
      final matchesStatus = state.selectedStatusFilter == "All Status" ||
          cert.status.toLowerCase() == state.selectedStatusFilter.toLowerCase();

      final matchesType = state.selectedTypeFilter == "All Types" ||
          cert.certificateType.toLowerCase() ==
              state.selectedTypeFilter.toLowerCase();

      final matchesSearch = state.searchQuery.isEmpty ||
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

    AppLogger.info(
      'Approving certificate ID: $id',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    AppLogger.json(
      payload,
      tag: LogTags.doctor,
      subTag: '$_subTag/ApprovePayload',
    );

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.approve(
        id: id,
        doctorNotes: notes,
        fitnessStatus: fitnessStatus,
        validity: validity,
      );

      final statusCode = response.statusCode ?? 0;

      // ✅ Keep existing approval response parsing (may use success flag)
      if (statusCode >= 200 && statusCode < 300 && response.data["success"] == true) {
        AppLogger.success(
          'Certificate ID: $id approved successfully',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        await refresh();
        return true;
      }
      AppLogger.warning(
        'Certificate approval rejected by backend for ID: $id',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Approve certificate faulted',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }

  Future<bool> rejectCertificate(int id) async {
    AppLogger.info(
      'Rejecting certificate ID: $id',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.reject(id);

      final statusCode = response.statusCode ?? 0;
      // ✅ Keep existing rejection response parsing
      if (statusCode >= 200 && statusCode < 300 && response.data["success"] == true) {
        AppLogger.success(
          'Certificate ID: $id rejected successfully',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        await loadRequests();
        return true;
      }
      AppLogger.warning(
        'Certificate rejection failed on backend for ID: $id',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Reject certificate faulted',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }

  Future<void> refresh() async {
    final previousDataExists = state.pendingCertificates.isNotEmpty ||
        state.issuedCertificates.isNotEmpty;

    // ✅ If data exists, use refreshing flag (keeps UI visible)
    if (previousDataExists) {
      state = state.copyWith(refreshing: true, clearError: true);
      AppLogger.info(
        'Refreshing certificate data (preserving existing UI)',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    } else {
      state = state.copyWith(loading: true, clearError: true);
      AppLogger.info(
        'Loading certificate data (first load)',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final reqResponse = await repository.getRequests();
      final issuedResponse = await repository.getIssuedCertificates();

      // ✅ Preserve existing data before refresh
      List<DoctorCertificateRequestModel> pendingList =
          state.pendingCertificates;
      List<DoctorCertificateRequestModel> issuedList =
          state.issuedCertificates;

      // ✅ Safely parse /certificate/requests (direct array)
      if (reqResponse.statusCode != null &&
          reqResponse.statusCode! >= 200 &&
          reqResponse.statusCode! < 300) {
        pendingList = _parseCertificateList(reqResponse.data, '/certificate/requests');
        AppLogger.info(
          'Refresh: Parsed ${pendingList.length} pending certificates',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      } else {
        AppLogger.warning(
          'Refresh: Failed to fetch pending certificates. Status: ${reqResponse.statusCode}. Preserving existing data (${pendingList.length} items)',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      }

      // ✅ Safely parse /certificate/issued (may be empty array or wrapped)
      if (issuedResponse.statusCode != null &&
          issuedResponse.statusCode! >= 200 &&
          issuedResponse.statusCode! < 300) {
        issuedList = _parseCertificateList(issuedResponse.data, '/certificate/issued');
        AppLogger.info(
          'Refresh: Parsed ${issuedList.length} issued certificates',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      } else {
        AppLogger.warning(
          'Refresh: Failed to fetch issued certificates. Status: ${issuedResponse.statusCode}. Preserving existing data (${issuedList.length} items)',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
      }

      AppLogger.success(
        'Global certificate sync complete. Pending: ${pendingList.length}, Issued: ${issuedList.length}',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        loading: false,
        refreshing: false,
        pendingCertificates: pendingList,
        issuedCertificates: issuedList,
        clearError: true,
      );
    } catch (e, st) {
      state = state.copyWith(
        loading: false,
        refreshing: false,
      );
      AppLogger.exception(
        e,
        st,
        message: 'Global synchronization pipeline crash',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
    }
  }
}