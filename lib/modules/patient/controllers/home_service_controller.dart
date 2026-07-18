import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/models/patient/home_service_booking_model.dart';
import '../repositories/patient_homecare_repository.dart';

class HomeServiceBookingState {
  final HomeServiceBookingModel bookingModel;
  final bool isLoading;
  final String? errorMessage;

  const HomeServiceBookingState({
    this.bookingModel = const HomeServiceBookingModel(),
    this.isLoading = false,
    this.errorMessage,
  });

  HomeServiceBookingState copyWith({
    HomeServiceBookingModel? bookingModel,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeServiceBookingState(
      bookingModel: bookingModel ?? this.bookingModel,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final homeServiceBookingProvider =
    NotifierProvider<HomeServiceBookingNotifier, HomeServiceBookingState>(
      HomeServiceBookingNotifier.new,
    );

class HomeServiceBookingNotifier extends Notifier<HomeServiceBookingState> {
  static const String _subTag = 'HomeServiceBookingNotifier';

  // 🎯 Optimization Check: Class-level instance injection for single allocation setup safely
  final Geocoding _geocoding = Geocoding();

  @override
  HomeServiceBookingState build() {
    return const HomeServiceBookingState();
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
      bookingModel: state.bookingModel.copyWith(
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
      ),
    );
  }

  Future<bool> createBooking() async {
    if (state.isLoading) return false;
    state = state.copyWith(isLoading: true, clearError: true);

    final model = state.bookingModel;
    final payload = {
      "full_name": model.fullName,
      "patient_age": int.tryParse(model.patientAge) ?? 0,
      "patient_gender": model.patientGender,
      "patient_latitude": model.latitude,
      "patient_longitude": model.longitude,
      "gender_preference": model.preferredCaregiverGender,
      "emergency_booking": model.needEmergencyService,
      "address": model.address,
      "contact_number": model.contactNumber,
      "service_type": model.selectedServiceType,
      "medical_condition": model.medicalCondition,
      "duration_type": model.durationType,
      "number_of_days": int.tryParse(model.numberOfDays) ?? 0,
      "preferred_date": model.startDate?.toIso8601String().split("T").first,
      "time_slot": model.timePreference,
      "notes": model.additionalNotes,
    };

    AppLogger.info(
      'Submitting home care request pipeline',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(patientHomeCareRepositoryProvider);
      final response = await repository.createBooking(payload);

      final statusCode = response.statusCode;

      // 🎯 FIXED FINAL: Removed redundant null-check condition to resolve dead code matching contract analyzer flawlessly
      if (statusCode! >= 200 && statusCode < 300) {
        state = state.copyWith(isLoading: false);
        AppLogger.success(
          'Home care service instance deployed successfully',
          tag: LogTags.patient,
          subTag: _subTag,
        );
        return response.data["success"] == true;
      } else {
        final msg =
            response.data["message"] ?? "Booking failed from server edge";
        state = state.copyWith(errorMessage: msg, isLoading: false);
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(
        errorMessage: "Booking runtime failure. Retry setup.",
        isLoading: false,
      );
      AppLogger.exception(
        e,
        st,
        message: 'Home care booking fatal execution failure',
        tag: LogTags.patient,
        subTag: _subTag,
      );
      return false;
    }
  }

  Future<void> fetchCurrentLocation(
    TextEditingController addressController,
  ) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("Location services are disabled.");

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
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // 🎯 FIXED OPTIMIZATION: Utilizing pre-allocated instance reference context cleanly
      final placemarks = await _geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String address = "";

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
        ].where((value) => value != null && value.trim().isNotEmpty).join(', ');
      }

      addressController.text = address;

      state = state.copyWith(
        isLoading: false,
        bookingModel: state.bookingModel.copyWith(
          address: address,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (e, st) {
      state = state.copyWith(
        errorMessage: e.toString().replaceFirst("Exception: ", ""),
        isLoading: false,
      );
      AppLogger.exception(
        e,
        st,
        message: 'Location hardware link telemetry failure',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }
}
