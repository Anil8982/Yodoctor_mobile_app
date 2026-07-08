import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/manual_booking_service.dart';

class ManualBookingState {
  final bool loading;

  const ManualBookingState({this.loading = false});

  ManualBookingState copyWith({bool? loading}) {
    return ManualBookingState(loading: loading ?? this.loading);
  }
}

class ManualBookingNotifier extends Notifier<ManualBookingState> {
  final ManualBookingService _service = ManualBookingService();

  final formKey = GlobalKey<FormState>();

  final patientNameController = TextEditingController();
  final mobileController = TextEditingController();
  final ageController = TextEditingController();

  String selectedShift = "Evening Shift";

  @override
  ManualBookingState build() {
    ref.onDispose(() {
      patientNameController.dispose();
      mobileController.dispose();
      ageController.dispose();
    });

    return const ManualBookingState();
  }

  void changeShift(String shift) {
    selectedShift = shift;
    ref.notifyListeners();
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    state = state.copyWith(loading: true);

    try {
      await _service.bookPatient(
        patientName: patientNameController.text.trim(),
        patientMobile: mobileController.text.trim(),
        patientAge: int.tryParse(ageController.text) ?? 0,
        slot: selectedShift == "Morning Shift" ? "MORNING" : "EVENING",
      );

      patientNameController.clear();
      mobileController.clear();
      ageController.clear();
      selectedShift = "Evening Shift";

      state = state.copyWith(loading: false);

      ref.notifyListeners();

      return true;
    } catch (_) {
      state = state.copyWith(loading: false);
      return false;
    }
  }
}

final manualBookingProvider =
    NotifierProvider<ManualBookingNotifier, ManualBookingState>(
      ManualBookingNotifier.new,
    );
