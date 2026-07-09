import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../core/models/doctor/doctor_certificate_detail_model.dart';
import '../../../core/models/doctor/doctor_document_model.dart';
import '../repositories/doctor_certificate_repository.dart';

class DoctorCertificateReviewState {
  final bool loading;
  final DoctorCertificateDetailModel? detail;
  final List<DoctorDocumentModel> documents;
  final String? errorMessage;

  const DoctorCertificateReviewState({
    this.loading = false,
    this.detail,
    this.documents = const [],
    this.errorMessage,
  });

  DoctorCertificateReviewState copyWith({
    bool? loading,
    DoctorCertificateDetailModel? detail,
    bool clearDetail = false,
    List<DoctorDocumentModel>? documents,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorCertificateReviewState(
      loading: loading ?? this.loading,
      detail: clearDetail ? null : (detail ?? this.detail),
      documents: documents ?? this.documents,
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

  final formKey = GlobalKey<FormState>();
  final notesController = TextEditingController();
  String fitnessStatus = "";
  int validity = 30;

  @override
  DoctorCertificateReviewState build() {
    AppLogger.info('DoctorCertificateReviewNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);
    ref.onDispose(() {
      notesController.dispose();
    });
    return const DoctorCertificateReviewState();
  }

  Future<void> load(int requestId) async {
    state = state.copyWith(loading: true, clearError: true, clearDetail: true);
    AppLogger.info('Loading certificate review workspace metrics for ID: $requestId', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);

      final detailRes = await repository.getRequestDetails(requestId);
      final docsRes = await repository.getDocuments(requestId);

      final detailStatus = detailRes.statusCode ?? 0;
      final docsStatus = docsRes.statusCode ?? 0;

      if (detailStatus >= 200 && detailStatus < 300 && docsStatus >= 200 && docsStatus < 300) {
        final detail = DoctorCertificateDetailModel.fromJson(detailRes.data);

        final rawDocs = docsRes.data is Map ? (docsRes.data["data"] as List? ?? []) : (docsRes.data as List? ?? []);
        final docs = rawDocs.map((e) => DoctorDocumentModel.fromJson(e)).toList();

        AppLogger.success('Certificate details and documents loaded successfully for ID: $requestId', tag: LogTags.doctor, subTag: _subTag);
        AppLogger.json(detailRes.data, tag: LogTags.doctor, subTag: '$_subTag/DetailData');

        state = state.copyWith(loading: false, detail: detail, documents: docs);
      } else {
        AppLogger.warning('Failed to load metadata. DetailStatus: $detailStatus, DocsStatus: $docsStatus', tag: LogTags.doctor, subTag: _subTag);
        state = state.copyWith(loading: false, errorMessage: "Failed to load certificate details");
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to load certificate details");
      AppLogger.exception(e, st, message: 'Fatal exception within review metadata loader', tag: LogTags.doctor, subTag: _subTag);
    }
  }

  void changeFitnessStatus(String value) {
    AppLogger.info('Fitness status changed locally to: $value', tag: LogTags.doctor, subTag: _subTag);
    fitnessStatus = value;
  }

  void changeValidity(int days) {
    AppLogger.info('Validity period changed locally to: $days days', tag: LogTags.doctor, subTag: _subTag);
    validity = days;
  }

  Future<bool> approve() async {
    if (state.detail == null || state.loading) return false;
    state = state.copyWith(loading: true, clearError: true);

    final payload = {
      "id": state.detail!.id,
      "doctorNotes": notesController.text.trim(),
      "fitnessStatus": fitnessStatus,
      "validity": validity,
    };

    AppLogger.info('Submitting certificate approval for ID: ${state.detail!.id}', tag: LogTags.doctor, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.doctor, subTag: '$_subTag/ApprovePayload');

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.approve(
        id: state.detail!.id,
        doctorNotes: notesController.text.trim(),
        fitnessStatus: fitnessStatus,
        validity: validity,
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300 && response.data["success"] == true) {
        AppLogger.success('Certificate approved successfully on backend', tag: LogTags.doctor, subTag: _subTag);
        state = state.copyWith(loading: false);
        return true;
      }

      final msg = response.data["message"] ?? "Approval operation denied";
      AppLogger.warning('Certificate approval rejected by backend: $msg', tag: LogTags.doctor, subTag: _subTag);
      state = state.copyWith(loading: false, errorMessage: msg);
      return false;
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Approval action failed");
      AppLogger.exception(e, st, message: 'Approve transmission crash', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }

  Future<bool> reject() async {
    if (state.detail == null || state.loading) return false;
    state = state.copyWith(loading: true, clearError: true);

    AppLogger.info('Submitting certificate rejection for ID: ${state.detail!.id}', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorCertificateRepositoryProvider);
      final response = await repository.reject(state.detail!.id);

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300 && response.data["success"] == true) {
        AppLogger.success('Certificate rejected successfully on backend', tag: LogTags.doctor, subTag: _subTag);
        state = state.copyWith(loading: false);
        return true;
      }

      final msg = response.data["message"] ?? "Rejection action dropped";
      AppLogger.warning('Certificate rejection failed on backend: $msg', tag: LogTags.doctor, subTag: _subTag);
      state = state.copyWith(loading: false, errorMessage: msg);
      return false;
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Rejection action failed");
      AppLogger.exception(e, st, message: 'Reject transmission crash', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }
}