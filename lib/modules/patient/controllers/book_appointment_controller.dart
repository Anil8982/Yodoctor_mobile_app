import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../repositories/patient_appointment_repository.dart';
import '../models/appointment/book_appointment_request.dart';
import '../models/appointment/book_appointment_response.dart';
import '../models/family/family_member_model.dart';

class BookAppointmentState {
  final AsyncValue<BookAppointmentResponse?> bookingStatus;
  final bool isSelf;
  final FamilyMemberModel? selectedFamilyMember;
  final DateTime selectedDate;
  final String selectedSession;

  BookAppointmentState({
    required this.bookingStatus,
    this.isSelf = true,
    this.selectedFamilyMember,
    required this.selectedDate,
    this.selectedSession = 'Morning',
  });

  BookAppointmentState copyWith({
    AsyncValue<BookAppointmentResponse?>? bookingStatus,
    bool? isSelf,
    FamilyMemberModel? selectedFamilyMember,
    DateTime? selectedDate,
    String? selectedSession,
  }) {
    return BookAppointmentState(
      bookingStatus: bookingStatus ?? this.bookingStatus,
      isSelf: isSelf ?? this.isSelf,
      selectedFamilyMember: selectedFamilyMember ?? this.selectedFamilyMember,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSession: selectedSession ?? this.selectedSession,
    );
  }
}

final bookAppointmentControllerProvider =
NotifierProvider<BookAppointmentController, BookAppointmentState>(
  BookAppointmentController.new,
);

class BookAppointmentController extends Notifier<BookAppointmentState> {
  static const String _subTag = 'BookAppointmentController';

  @override
  BookAppointmentState build() {
    return BookAppointmentState(
      bookingStatus: const AsyncData(null),
      selectedDate: DateTime.now(),
    );
  }

  void updateProfileType(bool isSelf) {
    state = state.copyWith(isSelf: isSelf);
  }

  void updateFamilyMember(FamilyMemberModel? member) {
    state = state.copyWith(selectedFamilyMember: member);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateSession(String session) {
    state = state.copyWith(selectedSession: session);
  }

  bool get canConfirm {
    if (state.isSelf) return true;
    return state.selectedFamilyMember != null;
  }

  /// Handles the execution of appointment booking safely
  Future<bool> book(String doctorId) async {
    AppLogger.info('Initiating appointment booking flow in repositories', tag: LogTags.patient, subTag: _subTag);

    // Set loading state safely
    state = state.copyWith(bookingStatus: const AsyncLoading());
    final repository = ref.read(patientAppointmentRepositoryProvider);

    final request = BookAppointmentRequest(
      doctorId: doctorId,
      appointmentType: "CLINIC",
      appointmentDate: state.selectedDate.toIso8601String().split('T').first,
      slot: state.selectedSession == "Morning" ? "MORNING" : "EVENING",
      familyMemberIds: state.isSelf ? [] : [state.selectedFamilyMember!.id],
    );

    try {
      final res = await repository.bookAppointment(request);

      if (res.data is Map<String, dynamic>) {
        AppLogger.json(res.data as Map<String, dynamic>, tag: LogTags.api, subTag: _subTag);
      }

      final payload = res.data["data"] as Map<String, dynamic>;
      final responseModel = BookAppointmentResponse.fromJson(payload);

      state = state.copyWith(bookingStatus: AsyncData(responseModel));
      AppLogger.success('Appointment booking committed and synchronized successfully.', tag: LogTags.patient, subTag: _subTag);
      return true;
    } catch (errorObj, st) {
      String userError = "Booking Failed";

      if (errorObj is DioException) {
        final rawResponseData = errorObj.response?.data;
        if (rawResponseData is Map<String, dynamic>) {
          userError = rawResponseData["message"] ?? userError;
        }
      } else {
        userError = errorObj.toString();
      }

      state = state.copyWith(bookingStatus: AsyncError(userError, st));
      AppLogger.exception(errorObj, st, message: userError, tag: LogTags.patient, subTag: _subTag);
      return false;
    }
  }
}