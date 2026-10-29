import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:debug_bubble/debug_bubble.dart';
import 'package:yodoctor/core/constants/log_tags.dart';

import '../models/appointment/prescription_model.dart';
import '../repositories/prescription_repository.dart';

class PrescriptionState {
  final bool loading;
  final bool saving;
  final bool uploading;
  final bool downloading;
  final PrescriptionModel? prescription;
  final List<int>? downloadedFileBytes;
  final String? errorMessage;
  final String? successMessage;

  const PrescriptionState({
    this.loading = false,
    this.saving = false,
    this.uploading = false,
    this.downloading = false,
    this.prescription,
    this.downloadedFileBytes,
    this.errorMessage,
    this.successMessage,
  });

  PrescriptionState copyWith({
    bool? loading,
    bool? saving,
    bool? uploading,
    bool? downloading,
    PrescriptionModel? prescription,
    bool clearPrescription = false,
    List<int>? downloadedFileBytes,
    bool clearDownloadedFile = false,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return PrescriptionState(
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      uploading: uploading ?? this.uploading,
      downloading: downloading ?? this.downloading,
      prescription: clearPrescription
          ? null
          : prescription ?? this.prescription,
      downloadedFileBytes: clearDownloadedFile
          ? null
          : downloadedFileBytes ?? this.downloadedFileBytes,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }
}

final prescriptionControllerProvider =
NotifierProvider<PrescriptionController, PrescriptionState>(
  PrescriptionController.new,
);

class PrescriptionController extends Notifier<PrescriptionState> {
  static const String _subTag = 'PrescriptionController';

  @override
  PrescriptionState build() {
    DebugLog.info(
      'PrescriptionController initialized',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    return const PrescriptionState();
  }

  String? _extractBackendMessage(dynamic data) {
    if (data is Map) {
      return data['message']?.toString() ?? data['error']?.toString();
    }
    return null;
  }

  /// API 1: Add prescription
  Future<bool> savePrescription({
    required String appointmentId,
    required PrescriptionModel prescription,
  }) async {
    state = state.copyWith(
      saving: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      final repository = ref.read(prescriptionRepositoryProvider);

      final response = await repository.addPrescription(
        appointmentId: appointmentId,
        prescription: prescription,
      );

      final statusCode = response.statusCode ?? 0;
      final success = statusCode >= 200 && statusCode < 300;

      if (!success) {
        final backendMsg = _extractBackendMessage(response.data);
        state = state.copyWith(
          saving: false,
          errorMessage: backendMsg ?? 'Failed to save prescription.',
        );
        return false;
      }

      final successMsg = _extractBackendMessage(response.data) ??
          'Prescription saved successfully.';

      state = state.copyWith(
        saving: false,
        successMessage: successMsg,
      );

      DebugLog.success(
        'Prescription saved successfully',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      return true;
    } on DioException catch (e) {
      final backendMsg = _extractBackendMessage(e.response?.data);

      DebugLog.error(
        'Failed to save prescription: ${backendMsg ?? e.message}',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        saving: false,
        errorMessage: backendMsg ?? 'Unable to save prescription. Please try again.',
      );

      return false;
    } catch (_) {
      DebugLog.error(
        'Failed to save prescription',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        saving: false,
        errorMessage: 'Unable to save prescription. Please try again.',
      );

      return false;
    }
  }

  /// API 2: Get prescription
  Future<PrescriptionModel?> getPrescription(
      String appointmentId,
      ) async {
    state = state.copyWith(
      loading: true,
      clearError: true,
      clearSuccess: true,
      clearPrescription: true,
    );

    try {
      final repository = ref.read(prescriptionRepositoryProvider);

      final prescription = await repository.getPrescription(appointmentId);

      state = state.copyWith(
        loading: false,
        prescription: prescription,
      );

      DebugLog.success(
        'Prescription fetched successfully',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      return prescription;
    } on DioException catch (e) {
      // 404 is an expected fresh state, not a system failure
      if (e.response?.statusCode == 404) {
        state = state.copyWith(
          loading: false,
          clearPrescription: true,
          clearError: true,
        );

        DebugLog.info(
          'No existing prescription found (404)',
          tag: LogTags.doctor,
          subTag: _subTag,
        );

        return null;
      }

      final backendMsg = _extractBackendMessage(e.response?.data);

      DebugLog.error(
        'Failed to fetch prescription: ${backendMsg ?? e.message}',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        loading: false,
        errorMessage: backendMsg ?? 'Unable to load prescription.',
      );

      return null;
    } catch (_) {
      DebugLog.error(
        'Failed to fetch prescription',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        loading: false,
        errorMessage: 'Unable to load prescription.',
      );

      return null;
    }
  }

  /// API 2: Download generated PDF or original uploaded file
  Future<List<int>?> downloadPrescription({
    required String appointmentId,
    required String format,
  }) async {
    state = state.copyWith(
      downloading: true,
      clearError: true,
      clearSuccess: true,
      clearDownloadedFile: true,
    );

    try {
      final repository = ref.read(prescriptionRepositoryProvider);

      final bytes = await repository.downloadPrescription(
        appointmentId: appointmentId,
        format: format,
      );

      state = state.copyWith(
        downloading: false,
        downloadedFileBytes: bytes,
        successMessage: 'Prescription file downloaded successfully.',
      );

      return bytes;
    } on DioException catch (e) {
      final backendMsg = _extractBackendMessage(e.response?.data);

      DebugLog.error(
        'Failed to download prescription: ${backendMsg ?? e.message}',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        downloading: false,
        errorMessage: backendMsg ??
            (format == 'original'
                ? 'Original prescription file is unavailable.'
                : 'Unable to download prescription.'),
      );

      return null;
    } catch (_) {
      DebugLog.error(
        'Failed to download prescription',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        downloading: false,
        errorMessage: format == 'original'
            ? 'Original prescription file is unavailable.'
            : 'Unable to download prescription.',
      );

      return null;
    }
  }

  /// API 3: Upload prescription image or PDF
  Future<bool> uploadPrescription({
    required String appointmentId,
    required String filePath,
  }) async {
    state = state.copyWith(
      uploading: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      final repository = ref.read(prescriptionRepositoryProvider);

      final response = await repository.uploadPrescription(
        appointmentId: appointmentId,
        filePath: filePath,
      );

      final statusCode = response.statusCode ?? 0;
      final success = statusCode >= 200 && statusCode < 300;

      if (!success) {
        final backendMsg = _extractBackendMessage(response.data);
        state = state.copyWith(
          uploading: false,
          errorMessage: backendMsg ?? 'Failed to upload prescription.',
        );
        return false;
      }

      final successMsg = _extractBackendMessage(response.data) ??
          'Prescription uploaded successfully.';

      state = state.copyWith(
        uploading: false,
        successMessage: successMsg,
      );

      DebugLog.success(
        'Prescription uploaded successfully',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      return true;
    } on DioException catch (e) {
      final backendMsg = _extractBackendMessage(e.response?.data);

      DebugLog.error(
        'Failed to upload prescription: ${backendMsg ?? e.message}',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        uploading: false,
        errorMessage: backendMsg ?? 'Unable to upload prescription. Please try again.',
      );

      return false;
    } catch (_) {
      DebugLog.error(
        'Failed to upload prescription',
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      state = state.copyWith(
        uploading: false,
        errorMessage: 'Unable to upload prescription. Please try again.',
      );

      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(
      clearError: true,
      clearSuccess: true,
    );
  }

  void reset() {
    state = const PrescriptionState();
  }
}