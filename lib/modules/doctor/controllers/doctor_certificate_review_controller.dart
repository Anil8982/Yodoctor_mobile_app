import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_certificate_detail_model.dart';
import 'package:yodoctor/modules/doctor/models/certificate/doctor_document_model.dart';
import '../repositories/doctor_certificate_repository.dart';

class DoctorCertificateReviewState {
  final bool loading;
  final bool submitting;
  final DoctorCertificateDetailModel? detail;
  final List<DoctorDocumentModel> documents;
  final String fitnessStatus;
  final int validity;
  final String? errorMessage;

  const DoctorCertificateReviewState({
    this.loading = false,
    this.submitting = false,
    this.detail,
    this.documents = const [],
    this.fitnessStatus = "",
    this.validity = 30,
    this.errorMessage,
  });

  DoctorCertificateReviewState copyWith({
    bool? loading,
    bool? submitting,
    DoctorCertificateDetailModel? detail,
    bool clearDetail = false,
    List<DoctorDocumentModel>? documents,
    String? fitnessStatus,
    int? validity,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorCertificateReviewState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      detail: clearDetail ? null : (detail ?? this.detail),
      documents: documents ?? this.documents,
      fitnessStatus: fitnessStatus ?? this.fitnessStatus,
      validity: validity ?? this.validity,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final doctorCertificateReviewProvider =
NotifierProvider<DoctorCertificateReviewNotifier, DoctorCertificateReviewState>(
  DoctorCertificateReviewNotifier.new,
);

class DoctorCertificateReviewNotifier extends Notifier<DoctorCertificateReviewState> {
  static const String _subTag = 'DoctorCertificateReviewNotifier';

  // ✅ REMOVED: formKey - moved to UI
  final notesController = TextEditingController();

  // ✅ Backward compatibility getters - UI expects these
  String get fitnessStatus => state.fitnessStatus;
  int get validity => state.validity;

  List<dynamic> _parseDirectList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    return [];
  }

  @override
  DoctorCertificateReviewState build() {
    AppLogger.info('DoctorCertificateReviewNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);
    ref.onDispose(notesController.dispose);
    return const DoctorCertificateReviewState();
  }

  Future<void> load(int requestId) async {
    state = state.copyWith(loading: true, clearError: true, clearDetail: true);
    AppLogger.info('Loading certificate review for ID: $requestId', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final detailRes = await repository.getRequestDetails(requestId);
      final docsRes = await repository.getDocuments(requestId);

      final detailOk = (detailRes.statusCode ?? 0) >= 200 && (detailRes.statusCode ?? 0) < 300;
      final docsOk = (docsRes.statusCode ?? 0) >= 200 && (docsRes.statusCode ?? 0) < 300;

      if (detailOk && docsOk) {
        final detail = DoctorCertificateDetailModel.fromJson(detailRes.data);

        final rawDocs = _parseDirectList(docsRes.data);
        final docs = rawDocs
            .map((e) {
          try {
            if (e is Map<String, dynamic>) {
              return DoctorDocumentModel.fromJson(e);
            }
            return null;
          } catch (_) {
            return null;
          }
        })
            .whereType<DoctorDocumentModel>()
            .toList();

        AppLogger.success('Certificate loaded for ID: $requestId', tag: LogTags.doctor, subTag: _subTag);

        if (detail.isFinalized) {
          notesController.text = detail.doctorNotes ?? '';
          state = state.copyWith(
            loading: false,
            detail: detail,
            documents: docs,
            fitnessStatus: detail.fitnessStatus ?? '',
            validity: detail.validityDays,
          );
        } else {
          notesController.clear();
          state = state.copyWith(
            loading: false,
            detail: detail,
            documents: docs,
            fitnessStatus: '',
            validity: 30,
          );
        }
      } else {
        state = state.copyWith(loading: false, errorMessage: "Failed to load certificate details");
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to load certificate details");
      AppLogger.exception(e, st, message: 'Load certificate failed', tag: LogTags.doctor, subTag: _subTag);
    }
  }

  void changeFitnessStatus(String value) {
    state = state.copyWith(fitnessStatus: value);
  }

  void changeValidity(int days) {
    state = state.copyWith(validity: days);
  }

  Future<bool> approve() async {
    if (state.detail == null || state.submitting) return false;
    if (state.detail!.isFinalized) {
      AppLogger.warning('Cannot approve finalized certificate', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }

    state = state.copyWith(submitting: true, clearError: true);

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.approve(
        id: state.detail!.id,
        doctorNotes: notesController.text.trim(),
        fitnessStatus: state.fitnessStatus,
        validity: state.validity,
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        state = state.copyWith(submitting: false);
        return true;
      }

      String errorMsg = "Approval failed";
      if (response.data is Map && response.data["message"] != null) {
        errorMsg = response.data["message"].toString();
      }

      state = state.copyWith(
        submitting: false,
        errorMessage: errorMsg,
      );
      return false;
    } on DioException catch (e) {
      String errorMsg = "Approval action failed";
      try {
        if (e.response?.data is Map) {
          final data = e.response?.data as Map;
          if (data["message"] != null) {
            errorMsg = data["message"].toString();
          }
        }
      } catch (_) {
        // Use fallback
      }

      state = state.copyWith(
        submitting: false,
        errorMessage: errorMsg,
      );
      AppLogger.exception(e, e.stackTrace, message: 'Approve failed with DioException', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      state = state.copyWith(submitting: false, errorMessage: "Approval action failed");
      AppLogger.exception(e, st, message: 'Approve failed', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }

  Future<bool> reject() async {
    if (state.detail == null || state.submitting) return false;
    if (state.detail!.isFinalized) {
      AppLogger.warning('Cannot reject finalized certificate', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }

    state = state.copyWith(submitting: true, clearError: true);

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.reject(state.detail!.id);

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        state = state.copyWith(submitting: false);
        return true;
      }

      String errorMsg = "Rejection failed";
      if (response.data is Map && response.data["message"] != null) {
        errorMsg = response.data["message"].toString();
      }

      state = state.copyWith(
        submitting: false,
        errorMessage: errorMsg,
      );
      return false;
    } on DioException catch (e) {
      String errorMsg = "Rejection action failed";
      try {
        if (e.response?.data is Map) {
          final data = e.response?.data as Map;
          if (data["message"] != null) {
            errorMsg = data["message"].toString();
          }
        }
      } catch (_) {
        // Use fallback
      }

      state = state.copyWith(
        submitting: false,
        errorMessage: errorMsg,
      );
      AppLogger.exception(e, e.stackTrace, message: 'Reject failed with DioException', tag: LogTags.doctor, subTag: _subTag);
      return false;
    } catch (e, st) {
      state = state.copyWith(submitting: false, errorMessage: "Rejection action failed");
      AppLogger.exception(e, st, message: 'Reject failed', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }
}