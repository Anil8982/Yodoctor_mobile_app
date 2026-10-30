import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
import '../repositories/manual_booking_repository.dart';

class ManualBookingState {
  final bool loading;
  final String selectedShift;
  final String? selectedGender;
  final String? genderError;
  final String? errorMessage;

  const ManualBookingState({
    this.loading = false,
    this.selectedShift = "Evening Shift",
    this.selectedGender,
    this.genderError,
    this.errorMessage,
  });

  ManualBookingState copyWith({
    bool? loading,
    String? selectedShift,
    String? selectedGender,
    String? errorMessage,
    String? genderError,
    bool clearGenderError = false,
    bool clearError = false,
  }) {
    return ManualBookingState(
      loading: loading ?? this.loading,
      selectedShift: selectedShift ?? this.selectedShift,
      selectedGender: selectedGender ?? this.selectedGender,
      genderError: clearGenderError ? null : (genderError ?? this.genderError),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final manualBookingProvider =
    NotifierProvider<ManualBookingNotifier, ManualBookingState>(
      ManualBookingNotifier.new,
    );

class ManualBookingNotifier extends Notifier<ManualBookingState> {
  static const String _subTag = 'ManualBookingNotifier';

  @override
  ManualBookingState build() {
    DebugLog.info(
      'ManualBookingNotifier Initialized',
      tag: LogTags.doctor,
      subTag: _subTag,
    );

    return ManualBookingState(selectedShift: _getDefaultShift());
  }

  String _getDefaultShift() {
    return DateTime.now().hour < 12 ? "Morning Shift" : "Evening Shift";
  }

  void changeShift(String shift) {
    DebugLog.info(
      'Shift changed locally to: $shift',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(selectedShift: shift);
  }

  void selectGender(String gender) {
    DebugLog.info(
      'Gender selection updated locally to: $gender',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(selectedGender: gender, genderError: null);
  }

  Future<bool> submit({
    required String patientName,
    required String mobile,
    required String age,
  }) async {
    if (state.selectedGender == null) {
      DebugLog.warning(
        'Manual Patient booking registration aborted: Missing selected Gender reference',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      state = state.copyWith(genderError: 'Please select gender');
      return false;
    }
    if (state.loading) {
      DebugLog.warning(
        'Submission blocked due to loading state',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }

    state = state.copyWith(loading: true, clearError: true);

    final mappedSlot = state.selectedShift == "Morning Shift"
        ? "MORNING"
        : "EVENING";
    final payload = {
      "patientName": patientName,
      "patientMobile": mobile,
      "patientGender": state.selectedGender!.toUpperCase(),
      "patientAge": int.tryParse(age) ?? 0,
      "slot": mappedSlot,
    };

    DebugLog.info(
      'Submitting manual walk-in registration pipeline request...',
      tag: LogTags.doctor,
      subTag: _subTag,
      json: payload,
    );

    try {
      final repository = ref.read(manualBookingRepositoryProvider);
      final response = await repository.bookPatient(
        patientName: patientName,
        patientMobile: mobile,
        patientGender: state.selectedGender!.toUpperCase(),
        patientAge: int.tryParse(age) ?? 0,
        slot: mappedSlot,
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        DebugLog.success(
          'Manual patient entry committed and synced successfully on backend',
          tag: LogTags.doctor,
          subTag: _subTag,
        );

        state = ManualBookingState(selectedShift: _getDefaultShift());
        return true;
      } else {
        final msg =
            response.data["message"] ?? "Failed to save walk-in appointment";
        DebugLog.warning(
          'Backend rejected manual booking submission. Status: $statusCode, Message: $msg',
          tag: LogTags.doctor,
          subTag: _subTag,
        );
        state = state.copyWith(loading: false, errorMessage: msg);
        return false;
      }
    } on DioException catch (e, st) {
      String message = "Booking transaction failure";

      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        message = e.response!.data["message"] ?? message;
      }

      state = state.copyWith(loading: false, errorMessage: message);

      DebugLog.error(
        message,
        error: e,
        stackTrace: st,
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      return false;
    } catch (e, st) {
      state = state.copyWith(
        loading: false,
        errorMessage: "Booking transaction failure",
      );
      DebugLog.error(
        'Fatal exception within manual booking engine thread',
        error: e,
        stackTrace: st,
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }
}
