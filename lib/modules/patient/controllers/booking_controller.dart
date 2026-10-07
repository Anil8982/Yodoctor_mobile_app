import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/modules/patient/models/lab/booking_state_model.dart';

class LabBookingNotifier extends Notifier<BookingStateModel> {
  static const String _subTag = 'LabBookingNotifier';
  final Geocoding _geocoding = Geocoding();

  @override
  BookingStateModel build() {
    AppLogger.info(
      'LabBookingNotifier Initialized',
      tag: LogTags.patient,
      subTag: _subTag,
    );
    return BookingStateModel(selectedDate: DateTime.now());
  }


  void updatePatientDetails({
    String? name,
    String? age,
    String? phone,
    String? gender,
  }) {
    if (gender == null) return;

    AppLogger.info(
      'Updating gender for lab booking',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    state = state.copyWith(gender: gender);
  }


  void setPatientDetailsForBooking({
    required String name,
    required String age,
    required String phone,
    String? gender,
  }) {
    AppLogger.info(
      'Setting patient details for booking submission',
      tag: LogTags.patient,
      subTag: _subTag,
    );

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

    AppLogger.info(
      'Updating booking address and coordinates',
      tag: LogTags.patient,
      subTag: _subTag,
    );
    AppLogger.json(
      payload,
      tag: LogTags.patient,
      subTag: '$_subTag/AddressPayload',
    );

    state = state.copyWith(
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }

  void setAddressForBooking(String address) {
    if (address.trim().isEmpty) return;
    state = state.copyWith(address: address.trim());
  }

  Future<void> fetchCurrentLocation(
    TextEditingController addressController,
  ) async {
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

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

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
      ].where((e) => e != null && e.trim().isNotEmpty).join(", ");
    }

    addressController.text = address;

    updateAddress(
      address,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  void selectDate(DateTime date) {
    AppLogger.info(
      'Selecting lab booking date: ${date.toIso8601String()}',
      tag: LogTags.patient,
      subTag: _subTag,
    );
    state = state.copyWith(selectedDate: date);
  }

  void selectTimeSlot(String slot) {
    AppLogger.info(
      'Selecting time slot: $slot',
      tag: LogTags.patient,
      subTag: _subTag,
    );
    state = state.copyWith(selectedTimeSlot: slot);
  }

  void reset() {
    AppLogger.info(
      'Resetting lab booking state to default',
      tag: LogTags.patient,
      subTag: _subTag,
    );
    state = BookingStateModel(selectedDate: DateTime.now());
  }
}

final labBookingProvider =
    NotifierProvider<LabBookingNotifier, BookingStateModel>(
      LabBookingNotifier.new,
    );
