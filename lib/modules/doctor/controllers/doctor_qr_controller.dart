import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../../core/models/doctor/doctor_qr_model.dart';
import '../repositories/doctor_qr_repository.dart';

class DoctorQrState {
  final bool loading;
  final DoctorQrModel? qr;
  final String? errorMessage;

  const DoctorQrState({
    this.loading = false,
    this.qr,
    this.errorMessage,
  });

  DoctorQrState copyWith({
    bool? loading,
    DoctorQrModel? qr,
    bool clearQr = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorQrState(
      loading: loading ?? this.loading,
      qr: clearQr ? null : (qr ?? this.qr),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
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
    AppLogger.info('DoctorQrNotifier Initialized', tag: LogTags.doctor, subTag: _subTag);
    Future.microtask(() async {
      await loadQr();
    });
    return const DoctorQrState();
  }

  Future<void> loadQr() async {
    if (state.loading) return;

    state = state.copyWith(loading: true, clearError: true);
    AppLogger.info('Requesting doctor custom QR data profile telemetry...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorQrRepositoryProvider);
      final response = await repository.getMyQr();
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final qrModel = DoctorQrModel.fromJson(Map<String, dynamic>.from(response.data));

        AppLogger.success('Doctor QR parameters successfully fetched and parsed', tag: LogTags.doctor, subTag: _subTag);
        AppLogger.json(response.data, tag: LogTags.doctor, subTag: '$_subTag/QrData');

        state = state.copyWith(loading: false, qr: qrModel);
      } else {
        final msg = response.data["message"] ?? "Failed to extract QR profile";
        state = state.copyWith(loading: false, errorMessage: msg);
        AppLogger.warning('QR fetch failed on remote point. Status: $statusCode, Message: $msg', tag: LogTags.doctor, subTag: _subTag);
      }
    } catch (e, st) {
      state = state.copyWith(loading: false, errorMessage: "Failed to load QR code metadata");
      AppLogger.exception(e, st, message: 'Fatal crash within QR synchronization engine loop', tag: LogTags.doctor, subTag: _subTag);
    }
  }

  Future<bool> downloadQr() async {
    if (state.qr == null) return false;
    state = state.copyWith(clearError: true);

    AppLogger.info('Triggering QR PDF compilation stream pipeline...', tag: LogTags.doctor, subTag: _subTag);

    try {
      final repository = ref.read(doctorQrRepositoryProvider);
      final response = await repository.downloadQr(
        doctorName: state.qr!.doctorName,
        specialization: state.qr!.specialization,
        qrValue: state.qr!.qrUrl,
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final dir = await getTemporaryDirectory();
        final file = File("${dir.path}/doctor_qr.pdf");

        await file.writeAsBytes(response.data);

        AppLogger.success('QR PDF buffer compiled and saved successfully at: ${file.path}', tag: LogTags.doctor, subTag: _subTag);
        await OpenFilex.open(file.path);

        return true;
      } else {
        final serverMsg = response.data?["message"] ?? "Download rejected by gateway infrastructure";
        state = state.copyWith(errorMessage: serverMsg);
        AppLogger.warning('QR PDF transmission download rejected. Status: $statusCode, Message: $serverMsg', tag: LogTags.doctor, subTag: _subTag);
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(errorMessage: "Failed to compile and download QR document");
      AppLogger.exception(e, st, message: 'QR document local generation cluster crash', tag: LogTags.doctor, subTag: _subTag);
      return false;
    }
  }
}