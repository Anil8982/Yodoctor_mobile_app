import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_saver/file_saver.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
import '../models/qr/doctor_qr_model.dart';
import '../repositories/doctor_qr_repository.dart';

class DoctorQrState {
  final bool loading;
  final bool downloadLoading;
  final DoctorQrModel? qr;
  final String? errorMessage;
  final String? downloadError;

  const DoctorQrState({
    this.loading = false,
    this.downloadLoading = false,
    this.qr,
    this.errorMessage,
    this.downloadError,
  });

  DoctorQrState copyWith({
    bool? loading,
    bool? downloadLoading,
    DoctorQrModel? qr,
    bool clearQr = false,
    String? errorMessage,
    bool clearError = false,
    String? downloadError,
    bool clearDownloadError = false,
  }) {
    return DoctorQrState(
      loading: loading ?? this.loading,
      downloadLoading: downloadLoading ?? this.downloadLoading,
      qr: clearQr ? null : (qr ?? this.qr),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      downloadError: clearDownloadError ? null : (downloadError ?? this.downloadError),
    );
  }
}

final doctorQrProvider = NotifierProvider<DoctorQrNotifier, DoctorQrState>(
  DoctorQrNotifier.new,
);

class DoctorQrNotifier extends Notifier<DoctorQrState> {
  static const String _subTag = 'DoctorQrNotifier';

  @override
  DoctorQrState build() {
    DebugLog.info('DoctorQrNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);
    Future.microtask(() async {
      await loadQr();
    });
    return const DoctorQrState();
  }

  Future<void> loadQr() async {
    if (state.loading) return;

    state = state.copyWith(loading: true, clearError: true);
    DebugLog.info('Requesting doctor custom QR data profile telemetry...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorQrRepositoryProvider);
      final response = await repository.getMyQr();
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final qrModel = DoctorQrModel.fromJson(Map<String, dynamic>.from(response.data));

        DebugLog.success(
          'Doctor QR parameters successfully fetched and parsed',
          tag: LogTags.doctor,
          subTag: _subTag,
          json: response.data,
        );

        state = state.copyWith(loading: false, qr: qrModel);
      } else {
        final msg = response.data["message"] ?? "Failed to extract QR profile";
        state = state.copyWith(loading: false, errorMessage: msg);
        DebugLog.warning('QR fetch failed on remote point. Status: $statusCode, Message: $msg', tag: LogTags.doctor, subTag: _subTag);
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to load QR code metadata");
      DebugLog.error(
        'Fatal crash within QR synchronization engine loop',
        tag: LogTags.doctor,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<bool> downloadQr() async {
    if (state.qr == null) return false;

    state = state.copyWith(
      downloadLoading: true,
      clearDownloadError: true,
    );

    DebugLog.info(
      'Triggering QR PDF download...',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorQrRepositoryProvider);

      final response = await repository.downloadQr(
        doctorName: state.qr!.doctorName,
        specialization: state.qr!.specialization,
        qrValue: state.qr!.qrUrl,
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final tempDir = await getTemporaryDirectory();

        final tempFile = File(
          '${tempDir.path}/doctor_qr_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );

        await tempFile.writeAsBytes(
          Uint8List.fromList(response.data as List<int>),
        );

        DebugLog.info(
          'QR PDF saved to temporary location',
          tag: LogTags.doctor,
          subTag: _subTag,
        );

        await FileSaver.instance.saveAs(
          name: 'doctor_qr',
          file: tempFile,
          fileExtension: 'pdf',
          mimeType: MimeType.pdf,
        );

        DebugLog.success(
          'QR PDF saved successfully.',
          tag: LogTags.doctor,
          subTag: _subTag,
        );

        state = state.copyWith(downloadLoading: false);

        return true;
      }

      final serverMsg =
          response.data?["message"] ?? "Download rejected by server";

      state = state.copyWith(
        downloadLoading: false,
        downloadError: serverMsg,
      );

      DebugLog.warning(
        'QR download failed. Status: $statusCode',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      return false;
    } catch (e, st) {
      state = state.copyWith(
        downloadLoading: false,
        downloadError: "Failed to download QR PDF",
      );

      DebugLog.error(
        'QR download failed',
        tag: LogTags.doctor,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return false;
    }
  }
}