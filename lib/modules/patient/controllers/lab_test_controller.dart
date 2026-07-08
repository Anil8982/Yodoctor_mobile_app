import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../modules/patient/models/lab/lab_category_model.dart';
import '../../../core/models/patient/lab_test_model.dart';
import '../../../services/patient_lab_service.dart';
import '../../../modules/patient/models/lab/lab_test_detail_model.dart';
import '../../../core/models/patient/booking_state_model.dart';

class LabState {
  final bool isLoading;

  final List<LabCategoryModel> categories;
  final LabTestDetailModel? selectedTest;
  final int selectedCategory;
  final List<LabPackage> packages;
  final List<LabPackage> tests;
  final List<LabPackage> popularTests;
  final List<LabPackage> cart;

  const LabState({
    this.isLoading = false,
    this.categories = const [],
    this.selectedCategory = 0,
    this.tests = const [],
    this.cart = const [],
    this.popularTests = const [],
    this.packages = const [],
    this.selectedTest,
  });

  LabState copyWith({
    bool? isLoading,
    List<LabCategoryModel>? categories,
    int? selectedCategory,
    List<LabPackage>? tests,
    List<LabPackage>? cart,
    List<LabPackage>? popularTests,
    List<LabPackage>? packages,
    LabTestDetailModel? selectedTest,
  }) {
    return LabState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      tests: tests ?? this.tests,
      cart: cart ?? this.cart,
      popularTests: popularTests ?? this.popularTests,
      packages: packages ?? this.packages,
      selectedTest: selectedTest ?? this.selectedTest,
    );
  }
}

class LabNotifier extends Notifier<LabState> {
  final PatientLabService _service = PatientLabService();

  @override
  LabState build() {
    Future.microtask(() async {
      await loadCategories();

      await loadPopularTests();

      await loadPackages();

      await loadTests();
    });

    return const LabState();
  }

  Future<void> loadPopularTests() async {
    try {
      final response = await _service.getPopularTests();

      final list = (response.data["data"] as List)
          .map((e) => LabPackage.fromJson(e))
          .toList();

      state = state.copyWith(popularTests: list);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> loadPackages() async {
    try {
      final response = await _service.getPackages();

      final list = (response.data["data"] as List)
          .map((e) => LabPackage.fromJson(e))
          .toList();

      state = state.copyWith(packages: list);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> loadTestDetails(int id) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _service.getTestDetails(id);

      state = state.copyWith(
        selectedTest: LabTestDetailModel.fromJson(response.data["data"]),
        isLoading: false,
      );
    } catch (e) {
      debugPrint(e.toString());

      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadCategories() async {
    try {
      final response = await _service.getCategories();

      final list = (response.data["data"] as List)
          .map((e) => LabCategoryModel.fromJson(e))
          .toList();

      state = state.copyWith(categories: list);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> createBooking({required BookingStateModel booking}) async {
    try {
      final response = await _service.createBooking({
        "patientName": booking.fullName,
        "age": int.tryParse(booking.age) ?? 0,
        "gender": booking.gender,
        "phone": booking.phoneNumber,
        "address": booking.address,
        "latitude": booking.latitude,
        "longitude": booking.longitude,
        "bookingDate": booking.selectedDate.toIso8601String().split("T").first,
        "bookingTime": booking.selectedTimeSlot,
        "tests": state.cart.map((e) => e.id).toList(),
      });

      if (response.data["success"] == true) {
        clearCart();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void selectCategory(int id) {
    state = state.copyWith(selectedCategory: id);
  }

  void toggleCartItem(LabPackage package) {
    final cart = [...state.cart];

    if (cart.any((e) => e.id == package.id)) {
      cart.removeWhere((e) => e.id == package.id);
    } else {
      cart.add(package);
    }

    state = state.copyWith(cart: cart);
  }

  void clearCart() {
    state = state.copyWith(cart: []);
  }

  List<LabPackage> get filteredPackages {
    final source = state.packages;

    if (state.selectedCategory == 0) {
      return state.packages;
    }

    return source.where((e) {
      return e.categoryId == state.selectedCategory;
    }).toList();
  }

  Future<void> loadTests() async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _service.getTests();

      final list = (response.data["data"] as List)
          .map((e) => LabPackage.fromJson(e))
          .toList();

      state = state.copyWith(tests: list, isLoading: false);
    } catch (e) {
      debugPrint(e.toString());

      state = state.copyWith(isLoading: false);
    }
  }
}

final labProvider = NotifierProvider<LabNotifier, LabState>(LabNotifier.new);
