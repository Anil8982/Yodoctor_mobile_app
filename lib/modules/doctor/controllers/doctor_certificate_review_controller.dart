import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/doctor/doctor_certificate_detail_model.dart';
import '../../../core/models/doctor/doctor_document_model.dart';
import '../../../services/doctor_certificate_service.dart';

class DoctorCertificateReviewState {
  final bool loading;

  final DoctorCertificateDetailModel? detail;

  final List<DoctorDocumentModel> documents;

  const DoctorCertificateReviewState({
    this.loading = false,
    this.detail,
    this.documents = const [],
  });

  DoctorCertificateReviewState copyWith({
    bool? loading,
    DoctorCertificateDetailModel? detail,
    List<DoctorDocumentModel>? documents,
  }) {
    return DoctorCertificateReviewState(
      loading: loading ?? this.loading,
      detail: detail ?? this.detail,
      documents: documents ?? this.documents,
    );
  }
}

class DoctorCertificateReviewNotifier
    extends Notifier<DoctorCertificateReviewState> {
  final DoctorCertificateService _service = DoctorCertificateService();

  final formKey = GlobalKey<FormState>();

  final notesController = TextEditingController();

  String fitnessStatus = "";

  int validity = 30;

  @override
  DoctorCertificateReviewState build() {
    ref.onDispose(() {
      notesController.dispose();
    });

    return const DoctorCertificateReviewState();
  }

  Future<void> load(int requestId) async {
    state = state.copyWith(loading: true);

    try {
      final detailRes = await _service.getRequestDetails(requestId);

      final docsRes = await _service.getDocuments(requestId);

      final detail = DoctorCertificateDetailModel.fromJson(detailRes.data);

      final docs = (docsRes.data as List)
          .map((e) => DoctorDocumentModel.fromJson(e))
          .toList();

      state = state.copyWith(loading: false, detail: detail, documents: docs);
    } catch (e) {
      state = state.copyWith(loading: false);
    }
  }

  void changeFitnessStatus(String value) {
    fitnessStatus = value;
  }

  void changeValidity(int days) {
    validity = days;
  }

  Future<bool> approve() async {
    if (state.detail == null) {
      return false;
    }

    await _service.approve(
      id: state.detail!.id,
      doctorNotes: notesController.text,
      fitnessStatus: fitnessStatus,
      validity: validity,
    );

    return true;
  }

  Future<bool> reject() async {
    if (state.detail == null) {
      return false;
    }

    await _service.reject(state.detail!.id);

    return true;
  }
}

final doctorCertificateReviewProvider =
    NotifierProvider.autoDispose<
      DoctorCertificateReviewNotifier,
      DoctorCertificateReviewState
    >(DoctorCertificateReviewNotifier.new);
