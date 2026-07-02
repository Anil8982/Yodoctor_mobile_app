import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/patient/home_service_booking_model.dart';

class HomeServiceBookingNotifier extends Notifier<HomeServiceBookingModel> {
  @override
  HomeServiceBookingModel build() {
    return const HomeServiceBookingModel();
  }

  void updateField({
    String? fullName,
    String? contactNumber,
    String? patientAge,
    String? patientGender,
    String? address,
    String? preferredCaregiverGender,
    bool? needEmergencyService,
    String? selectedServiceType,
    String? durationType,
    String? numberOfDays,
    DateTime? startDate,
    String? timePreference,
    String? medicalCondition,
    String? additionalNotes,
  }) {
    state = state.copyWith(
      fullName: fullName,
      contactNumber: contactNumber,
      patientAge: patientAge,
      patientGender: patientGender,
      address: address,
      preferredCaregiverGender: preferredCaregiverGender,
      needEmergencyService: needEmergencyService,
      selectedServiceType: selectedServiceType,
      durationType: durationType,
      numberOfDays: numberOfDays,
      startDate: startDate,
      timePreference: timePreference,
      medicalCondition: medicalCondition,
      additionalNotes: additionalNotes,
    );
  }
}

final homeServiceBookingProvider = NotifierProvider<HomeServiceBookingNotifier, HomeServiceBookingModel>(
  HomeServiceBookingNotifier.new,
);