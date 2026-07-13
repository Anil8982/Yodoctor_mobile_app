import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../../../modules/patient/models/lab/lab_category_model.dart';
import '../../../core/models/patient/lab_test_model.dart';
import '../repositories/patient_lab_repository.dart';
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
  final String? errorMessage;

  const LabState({
    this.isLoading = false,
    this.categories = const [],
    this.selectedCategory = 0,
    this.tests = const [],
    this.cart = const [],
    this.popularTests = const [],
    this.packages = const [],
    this.selectedTest,
    this.errorMessage,
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
    String? errorMessage,
    bool clearError = false,
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
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final labProvider = NotifierProvider<LabNotifier, LabState>(LabNotifier.new);

class LabNotifier extends Notifier<LabState> {
  static const String _subTag = 'LabNotifier';

  @override
  LabState build() {
    Future.microtask(() async {
      state = state.copyWith(isLoading: true, clearError: true);
      await loadCategories();
      await loadPopularTests();
      await loadPackages();
      await loadTests();
      state = state.copyWith(isLoading: false);
    });
    return const LabState();
  }

  Future<void> loadPopularTests() async {
    try {
      final repository = ref.read(patientLabRepositoryProvider);
      final response = await repository.getPopularTests();

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        final list = (response.data["data"] as List? ?? [])
            .map((e) => LabPackage.fromJson(e))
            .toList();
        state = state.copyWith(popularTests: list);
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Failed popular tests pipeline',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<void> loadPackages() async {
    try {
      final repository = ref.read(patientLabRepositoryProvider);
      final response = await repository.getPackages();

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        final list = (response.data["data"] as List? ?? [])
            .map((e) => LabPackage.fromJson(e))
            .toList();
        state = state.copyWith(packages: list);
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Failed packages load pipeline',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<void> loadTestDetails(int id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repository = ref.read(patientLabRepositoryProvider);
      final response = await repository.getTestDetails(id);

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        state = state.copyWith(
          selectedTest: LabTestDetailModel.fromJson(response.data["data"]),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Details not available",
        );
      }
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Failed to load test details",
      );
      AppLogger.exception(
        e,
        st,
        message: 'Test details breakdown pipeline',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<void> loadCategories() async {
    try {
      final repository = ref.read(patientLabRepositoryProvider);
      final response = await repository.getCategories();

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        final list = (response.data["data"] as List? ?? [])
            .map((e) => LabCategoryModel.fromJson(e))
            .toList();
        state = state.copyWith(categories: list);
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Categories extraction halted',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<bool> createBooking({required BookingStateModel booking}) async {
    if (state.isLoading) return false;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repository = ref.read(patientLabRepositoryProvider);
      final response = await repository.createBooking({
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

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 &&
          statusCode < 300 &&
          response.data["success"] == true) {
        clearCart();
        state = state.copyWith(isLoading: false);
        return true;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: response.data["message"] ?? "Booking failed",
      );
      return false;
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Booking submission halt",
      );
      AppLogger.exception(
        e,
        st,
        message: 'Lab test booking pipeline crash',
        tag: LogTags.patient,
        subTag: _subTag,
      );
      return false;
    }
  }

  void selectCategory(int id) => state = state.copyWith(selectedCategory: id);

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
    state = state.copyWith(cart: const []);
  }

  List<LabPackage> get filteredPackages {
    final source = state.packages;
    if (state.selectedCategory == 0) return source;
    return source.where((e) {
      return e.categoryId == state.selectedCategory;
    }).toList();
  }

  Future<void> loadTests() async {
    try {
      final repository = ref.read(patientLabRepositoryProvider);
      final response = await repository.getTests();

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        final list = (response.data["data"] as List? ?? [])
            .map((e) => LabPackage.fromJson(e))
            .toList();
        state = state.copyWith(tests: list);
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Tests catalog pipeline failed',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }
}
