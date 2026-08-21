import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/modules/doctor/models/certificate/certificate_service_model.dart';
import 'package:yodoctor/modules/doctor/repositories/doctor_certificate_service_repository.dart';

final doctorCertificateServiceProvider = NotifierProvider.autoDispose<
    DoctorCertificateServiceNotifier, CertificateServiceState>(
  DoctorCertificateServiceNotifier.new,
);

class CertificateServiceState {
  final CertificateServiceModel? service;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? saveMessage;
  final bool draftEnabled;
  final String draftFeeText;
  final String draftInstructions;

  const CertificateServiceState({
    this.service,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.saveMessage,
    this.draftEnabled = false,
    this.draftFeeText = '',
    this.draftInstructions = '',
  });

  bool get hasService => service != null;

  bool get isEnabled => draftEnabled;

  double get draftFee => double.tryParse(draftFeeText.trim()) ?? 0;

  String get instructions => draftInstructions;

  CertificateServiceState copyWith({
    CertificateServiceModel? service,
    bool clearService = false,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
    String? saveMessage,
    bool clearSaveMessage = false,
    bool? draftEnabled,
    String? draftFeeText,
    String? draftInstructions,
  }) {
    return CertificateServiceState(
      service: clearService ? null : service ?? this.service,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      saveMessage: clearSaveMessage ? null : saveMessage ?? this.saveMessage,
      draftEnabled: draftEnabled ?? this.draftEnabled,
      draftFeeText: draftFeeText ?? this.draftFeeText,
      draftInstructions: draftInstructions ?? this.draftInstructions,
    );
  }
}

class DoctorCertificateServiceNotifier
    extends Notifier<CertificateServiceState> {
  late final DoctorCertificateServiceRepository _repository;

  @override
  CertificateServiceState build() {
    _repository = ref.read(doctorCertificateServiceRepositoryProvider);

    return const CertificateServiceState();
  }

  Future<void> loadCertificateService({bool isRetry = false}) async {
    state = state.copyWith(
      isLoading: true,
      clearError: !isRetry,
      clearSaveMessage: true,
    );

    try {
      final response = await _repository.getCertificateService();
      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Invalid server response');
      }

      if (responseData['success'] != true) {
        throw Exception(
          responseData['message'] ?? 'Failed to load certificate service',
        );
      }

      final data = responseData['data'];

      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid certificate service data');
      }

      final service = CertificateServiceModel.fromJson(data);

      state = state.copyWith(
        service: service,
        isLoading: false,
        draftEnabled: service.enabled,
        draftFeeText: service.fee > 0 ? service.fee.toStringAsFixed(0) : '',
        draftInstructions: service.instructions ?? '',
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _errorMessage(e),
      );
    }
  }

  void updateDraftFee(String feeText) {
    state = state.copyWith(
      draftFeeText: feeText,
      clearError: true,
      clearSaveMessage: true,
    );
  }

  void updateDraftInstructions(String instructions) {
    state = state.copyWith(
      draftInstructions: instructions,
      clearError: true,
      clearSaveMessage: true,
    );
  }

  bool setLocalEnabled({required bool enabled}) {
    if (enabled) {
      final validationError = validateFee();

      if (validationError != null) {
        state = state.copyWith(
          errorMessage: validationError,
          clearSaveMessage: true,
        );
        return false;
      }
    }

    state = state.copyWith(
      draftEnabled: enabled,
      clearError: true,
      clearSaveMessage: true,
    );

    return true;
  }

  String? validateFee() {
    if (!state.draftEnabled) {
      return null;
    }

    if (state.draftFeeText.trim().isEmpty) {
      return 'Please enter the certificate fee.';
    }

    final fee = double.tryParse(state.draftFeeText.trim());

    if (fee == null || fee <= 0) {
      return 'Please enter a valid certificate fee.';
    }

    return null;
  }

  Future<bool> save() async {
    final validationError = validateFee();

    if (validationError != null) {
      state = state.copyWith(
        errorMessage: validationError,
        clearSaveMessage: true,
      );
      return false;
    }

    return _saveCertificateService(
      enabled: state.draftEnabled,
      fee: state.draftEnabled ? state.draftFee : 0,
      instructions: state.draftInstructions.trim().isEmpty
          ? null
          : state.draftInstructions.trim(),
    );
  }

  Future<bool> _saveCertificateService({
    required bool enabled,
    required double fee,
    String? instructions,
  }) async {
    state = state.copyWith(
      isSaving: true,
      clearError: true,
      clearSaveMessage: true,
    );

    try {
      final response = await _repository.saveCertificateService(
        enabled: enabled,
        fee: fee,
        instructions: instructions,
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Invalid server response');
      }

      if (responseData['success'] != true) {
        throw Exception(
          responseData['message'] ?? 'Failed to save certificate service',
        );
      }

      final data = responseData['data'];

      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid certificate service data');
      }

      final service = CertificateServiceModel.fromJson(data);

      state = state.copyWith(
        service: service,
        isSaving: false,
        draftEnabled: service.enabled,
        draftFeeText: service.fee > 0 ? service.fee.toStringAsFixed(0) : '',
        draftInstructions: service.instructions ?? '',
        saveMessage:
        responseData['message'] ?? 'Certificate service saved successfully',
        clearError: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _errorMessage(e),
      );

      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(
      clearError: true,
      clearSaveMessage: true,
    );
  }

  Future<void> retry() async {
    await loadCertificateService(isRetry: true);
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        final message = data['message'];

        if (message is String && message.trim().isNotEmpty) {
          return message.trim();
        }
      }

      switch (statusCode) {
        case 401:
          return 'Your session has expired. Please sign in again.';

        case 403:
          return 'You do not have permission to perform this action.';

        case 404:
          return 'The requested information could not be found.';

        case 500:
          return 'Something went wrong on the server. Please try again later.';
      }

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'The request took too long. Please try again.';
      }

      if (error.type == DioExceptionType.connectionError) {
        return 'Unable to connect to the server. Please check your internet connection and try again.';
      }

      return 'Something went wrong. Please try again.';
    }

    final message = error.toString();

    return message.isEmpty
        ? 'Something went wrong. Please try again.'
        : message.replaceFirst('Exception: ', '');
  }
}