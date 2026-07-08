import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/patient/home_service_booking_model.dart';
import 'package:yodoctor/services/patient_homecare_service.dart';

class HomeServiceBookingNotifier extends Notifier<HomeServiceBookingModel> {
  final PatientHomeCareService _service = PatientHomeCareService();
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
    double? latitude,
    double? longitude,
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
      latitude: latitude,
      longitude: longitude,
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

  Future<bool> createBooking() async {
    try {
      final response = await _service.createBooking({
        "full_name": state.fullName,
        "patient_age": int.tryParse(state.patientAge) ?? 0,
        "patient_gender": state.patientGender,

        "patient_latitude": state.latitude,
        "patient_longitude": state.longitude,

        "gender_preference": state.preferredCaregiverGender,
        "emergency_booking": state.needEmergencyService,

        "address": state.address,
        "contact_number": state.contactNumber,

        "service_type": state.selectedServiceType,
        "medical_condition": state.medicalCondition,

        "duration_type": state.durationType,
        "number_of_days": int.tryParse(state.numberOfDays) ?? 0,

        "preferred_date": state.startDate?.toIso8601String().split("T").first,

        "time_slot": state.timePreference,

        "notes": state.additionalNotes,
      });

      return response.data["success"] == true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

final homeServiceBookingProvider =
    NotifierProvider<HomeServiceBookingNotifier, HomeServiceBookingModel>(
      HomeServiceBookingNotifier.new,
    );
