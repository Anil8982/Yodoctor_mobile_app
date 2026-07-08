import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/models/patient/home_service_booking_model.dart';
import 'package:yodoctor/services/patient_homecare_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

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

  Future<void> fetchCurrentLocation(
    TextEditingController addressController,
  ) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission permanently denied.");
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "";

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        address =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
      }

      // TextField Update
      addressController.text = address;

      // Riverpod State Update
      updateField(
        address: address,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      print("Location Error: $e");
    }
  }
}

final homeServiceBookingProvider =
    NotifierProvider<HomeServiceBookingNotifier, HomeServiceBookingModel>(
      HomeServiceBookingNotifier.new,
    );
