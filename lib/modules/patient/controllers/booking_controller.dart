import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/models/patient/booking_state_model.dart';

class LabBookingNotifier extends Notifier<BookingStateModel> {
  static const String _subTag = 'LabBookingNotifier';

  @override
  BookingStateModel build() {
    AppLogger.info('LabBookingNotifier Initialized', tag: LogTags.patient, subTag: _subTag);
    return BookingStateModel(selectedDate: DateTime.now());
  }

  void updatePatientDetails({
    String? name,
    String? age,
    String? phone,
    String? gender,
  }) {
    final payload = {
      "fullName": ?name,
      "age": ?age,
      "phoneNumber": ?phone,
      "gender": ?gender,
    };

    AppLogger.info('Updating patient details for lab booking', tag: LogTags.patient, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.patient, subTag: '$_subTag/PatientDetails');

    state = state.copyWith(
      fullName: name,
      age: age,
      phoneNumber: phone,
      gender: gender,
    );
  }

  void updateAddress(String address, {double? latitude, double? longitude}) {
    final payload = {
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
    };

    AppLogger.info('Updating booking address and coordinates', tag: LogTags.patient, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.patient, subTag: '$_subTag/AddressPayload');

    state = state.copyWith(
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }

  void selectDate(DateTime date) {
    AppLogger.info('Selecting lab booking date: ${date.toIso8601String()}', tag: LogTags.patient, subTag: _subTag);
    state = state.copyWith(selectedDate: date);
  }

  void selectTimeSlot(String slot) {
    AppLogger.info('Selecting time slot: $slot', tag: LogTags.patient, subTag: _subTag);
    state = state.copyWith(selectedTimeSlot: slot);
  }

  void reset() {
    AppLogger.info('Resetting lab booking state to default', tag: LogTags.patient, subTag: _subTag);
    state = BookingStateModel(
      selectedDate: DateTime.now(),
    );
  }
}

final labBookingProvider =
NotifierProvider<LabBookingNotifier, BookingStateModel>(
  LabBookingNotifier.new,
);