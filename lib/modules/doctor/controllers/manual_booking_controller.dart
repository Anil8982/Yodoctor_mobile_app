import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../repositories/manual_booking_repository.dart';

class ManualBookingState {
  final bool loading;
  final String selectedShift;
  final String? errorMessage;

  const ManualBookingState({
    this.loading = false,
    this.selectedShift = "Evening Shift",
    this.errorMessage,
  });

  ManualBookingState copyWith({
    bool? loading,
    String? selectedShift,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ManualBookingState(
      loading: loading ?? this.loading,
      selectedShift: selectedShift ?? this.selectedShift,
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

  final formKey = GlobalKey<FormState>();
  final patientNameController = TextEditingController();
  final mobileController = TextEditingController();
  final ageController = TextEditingController();

  @override
  ManualBookingState build() {
    AppLogger.info(
      'ManualBookingNotifier Initialized',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    ref.onDispose(() {
      patientNameController.dispose();
      mobileController.dispose();
      ageController.dispose();
    });

    return ManualBookingState(selectedShift: _getDefaultShift());
  }

  String _getDefaultShift() {
    return DateTime.now().hour < 12 ? "Morning Shift" : "Evening Shift";
  }

  void changeShift(String shift) {
    AppLogger.info(
      'Shift changed locally to: $shift',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    state = state.copyWith(selectedShift: shift);
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate() || state.loading) {
      AppLogger.warning(
        'Form validation failed or submission blocked due to loading state',
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
      "patientName": patientNameController.text.trim(),
      "patientMobile": mobileController.text.trim(),
      "patientAge": int.tryParse(ageController.text) ?? 0,
      "slot": mappedSlot,
    };

    AppLogger.info(
      'Submitting manual walk-in registration pipeline request...',
      tag: LogTags.doctor,
      subTag: _subTag,
    );
    AppLogger.json(
      payload,
      tag: LogTags.doctor,
      subTag: '$_subTag/BookingPayload',
    );

    try {
      final repository = ref.read(manualBookingRepositoryProvider);
      final response = await repository.bookPatient(
        patientName: patientNameController.text.trim(),
        patientMobile: mobileController.text.trim(),
        patientAge: int.tryParse(ageController.text) ?? 0,
        slot: mappedSlot,
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        AppLogger.success(
          'Manual patient entry committed and synced successfully on backend',
          tag: LogTags.doctor,
          subTag: _subTag,
        );

        patientNameController.clear();
        mobileController.clear();
        ageController.clear();

        state = ManualBookingState(selectedShift: _getDefaultShift());
        return true;
      } else {
        final msg =
            response.data["message"] ?? "Failed to save walk-in appointment";
        AppLogger.warning(
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

      AppLogger.exception(
        e,
        st,
        message: message,
        tag: LogTags.doctor,
        subTag: _subTag,
      );

      return false;
    } catch (e, st) {
      state = state.copyWith(
        loading: false,
        errorMessage: "Booking transaction failure",
      );
      AppLogger.exception(
        e,
        st,
        message: 'Fatal exception within manual booking engine thread',
        tag: LogTags.doctor,
        subTag: _subTag,
      );
      return false;
    }
  }
}
