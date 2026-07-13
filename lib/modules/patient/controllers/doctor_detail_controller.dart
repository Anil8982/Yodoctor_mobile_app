import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../models/search/doctor_detail_model.dart';
import '../repositories/patient_search_repository.dart';

class DoctorDetailState {
  final bool isLoading;
  final String? errorMessage;
  final DoctorDetailModel? doctor;

  DoctorDetailState({this.isLoading = false, this.errorMessage, this.doctor});

  DoctorDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    DoctorDetailModel? doctor,
    bool clearDoctor = false,
  }) {
    return DoctorDetailState(
      isLoading: isLoading ?? this.isLoading,
      doctor: clearDoctor ? null : (doctor ?? this.doctor),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final doctorDetailControllerProvider =
    NotifierProvider<DoctorDetailController, DoctorDetailState>(
      DoctorDetailController.new,
    );

class DoctorDetailController extends Notifier<DoctorDetailState> {
  static const String _subTag = 'DoctorDetailController';

  @override
  DoctorDetailState build() {
    return DoctorDetailState();
  }

  Future<void> loadDoctor(int doctorId) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearDoctor: true,
    );

    AppLogger.info(
      'Loading doctor profile details',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(patientSearchRepositoryProvider);
      final response = await repository.getDoctorById(doctorId);

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 &&
          statusCode < 300 &&
          response.data["success"] == true) {
        if (response.data is Map<String, dynamic>) {
          AppLogger.json(
            response.data as Map<String, dynamic>,
            tag: LogTags.api,
            subTag: _subTag,
          );
        }

        final doctorModel = DoctorDetailModel.fromJson(response.data["doctor"]);
        state = state.copyWith(doctor: doctorModel, isLoading: false);
      } else {
        final errorMsg =
            response.data["message"] ?? "Failed to load doctor profile";
        state = state.copyWith(errorMessage: errorMsg, isLoading: false);
        AppLogger.warning(
          'Failed to load doctor profile: $errorMsg',
          tag: LogTags.patient,
          subTag: _subTag,
        );
      }
    } catch (e, stackTrace) {
      state = state.copyWith(
        errorMessage: "Failed to load doctor profile",
        isLoading: false,
      );
      AppLogger.exception(
        e,
        stackTrace,
        message: 'Failed to load doctor profile',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }
}
