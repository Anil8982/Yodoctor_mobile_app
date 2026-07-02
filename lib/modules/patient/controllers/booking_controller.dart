import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/patient/booking_state_model.dart';

class LabBookingNotifier extends Notifier<BookingStateModel> {
  @override
  BookingStateModel build() {
    return BookingStateModel(
      selectedDate: DateTime.now(),
    );
  }

  void updatePatientDetails({String? name, String? age, String? phone, String? gender}) {
    state = state.copyWith(
      fullName: name,
      age: age,
      phoneNumber: phone,
      gender: gender,
    );
  }

  void updateAddress(String address) {
    state = state.copyWith(fullAddress: address);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void selectTimeSlot(String slot) {
    state = state.copyWith(selectedTimeSlot: slot);
  }
}

final labBookingProvider = NotifierProvider<LabBookingNotifier, BookingStateModel>(
  LabBookingNotifier.new,
);