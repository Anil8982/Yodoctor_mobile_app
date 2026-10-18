import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/modules/payment/providers.dart';
import '../../../modules/patient/models/lab/lab_category_model.dart';
import '../models/lab/lab_test_model.dart';
import '../repositories/patient_lab_repository.dart';
import '../../../modules/patient/models/lab/lab_test_detail_model.dart';
import '../models/lab/booking_state_model.dart';
import 'package:yodoctor/modules/payment/controllers/razorpay_controller.dart';


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
  final bool isPaymentLoading;
  final String? paymentError;
  final String? lastOrderId;
  final int? lastBookingId;

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
    this.isPaymentLoading = false,
    this.paymentError,
    this.lastOrderId,
    this.lastBookingId,
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
    bool? isPaymentLoading,
    String? paymentError,
    String? lastOrderId,
    int? lastBookingId,
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
      isPaymentLoading: isPaymentLoading ?? this.isPaymentLoading,
      paymentError: paymentError ?? this.paymentError,
      lastOrderId: lastOrderId ?? this.lastOrderId,
      lastBookingId: lastBookingId ?? this.lastBookingId,
    );
  }
}

final labProvider = NotifierProvider<LabNotifier, LabState>(LabNotifier.new);

class LabNotifier extends Notifier<LabState> {
  static const String _subTag = 'LabNotifier';

  StreamSubscription<RazorpayEvent>? _razorpaySubscription;

  @override
  LabState build() {
    _listenToRazorpayEvents();

    ref.onDispose(() {
      _razorpaySubscription?.cancel();
    });

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

  void _listenToRazorpayEvents() {
    final razorpayController = ref.read(razorpayControllerProvider);

    _razorpaySubscription = razorpayController.events.listen(
          (event) {
        switch (event) {
          case RazorpaySuccess(:final paymentId, :final orderId, :final signature):
            _handlePaymentSuccess(paymentId, orderId, signature);
          case RazorpayFailure(:final message):
            _handlePaymentFailure(message);
          case RazorpayCancelled():
            _handlePaymentFailure('Payment cancelled');
          case RazorpayExternalWallet():
            break;
        }
      },
    );
  }

  // ============ Existing Methods ============

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
        e, st,
        message: 'Failed popular tests pipeline',
        tag: LogTags.patient, subTag: _subTag,
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
        e, st,
        message: 'Failed packages load pipeline',
        tag: LogTags.patient, subTag: _subTag,
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
        e, st,
        message: 'Test details breakdown pipeline',
        tag: LogTags.patient, subTag: _subTag,
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
        e, st,
        message: 'Categories extraction halted',
        tag: LogTags.patient, subTag: _subTag,
      );
    }
  }

  Future<int?> createBooking({required BookingStateModel booking}) async {
    if (state.isLoading) return null;
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
      if (statusCode >= 200 && statusCode < 300 && response.data["success"] == true) {
        final rawId = response.data["bookingDbId"];
        final id = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');

        AppLogger.success(
          'Lab booking created. ID: $id',
          tag: LogTags.patient,
          subTag: _subTag,
        );

        state = state.copyWith(isLoading: false, lastBookingId: id);
        return id;
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: response.data["message"] ?? "Booking failed",
      );
      return null;
    } catch (e, st) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Booking submission halt",
      );
      AppLogger.exception(
        e, st,
        message: 'Lab test booking pipeline crash',
        tag: LogTags.patient, subTag: _subTag,
      );
      return null;
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
    return source.where((e) => e.categoryId == state.selectedCategory).toList();
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
        e, st,
        message: 'Tests catalog pipeline failed',
        tag: LogTags.patient, subTag: _subTag,
      );
    }
  }

  // ============ Payment Methods ============

  Future<bool> initiatePayment(int bookingId) async {
    state = state.copyWith(isPaymentLoading: true, paymentError: null);

    try {
      final repository = ref.read(patientLabRepositoryProvider);
      final response = await repository.createLabPaymentOrder(bookingId);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final orderId = data['order_id'] as String;
        final key = data['razorpay_key'] as String;
        final amount = (data['amount'] as num) / 100;

        state = state.copyWith(
          lastOrderId: orderId,
          lastBookingId: bookingId,
        );

        AppLogger.info(
          'Opening Razorpay for lab booking #$bookingId, order: $orderId, amount: ₹$amount',
          tag: LogTags.patient, subTag: _subTag,
        );

        final razorpay = ref.read(razorpayControllerProvider);
        razorpay.openOrderCheckout(
          key: key,
          orderId: orderId,
          amount: amount,
          description: 'Lab Test Booking #$bookingId',
        );
        return true;
      }

      state = state.copyWith(
        isPaymentLoading: false,
        paymentError: response.data['message'] ?? 'Failed to create payment',
      );
      return false;
    } catch (e, st) {
      state = state.copyWith(
        isPaymentLoading: false,
        paymentError: 'Payment initiation failed',
      );
      AppLogger.exception(
        e, st,
        message: 'Lab payment initiation failed',
        tag: LogTags.patient, subTag: _subTag,
      );
      return false;
    }
  }

  Future<void> _handlePaymentSuccess(
      String? paymentId,
      String? orderId,
      String? signature,
      ) async {
    if (state.lastBookingId == null || state.lastOrderId == null) return;

    AppLogger.success(
      'Lab payment success: $paymentId, verifying...',
      tag: LogTags.patient, subTag: _subTag,
    );

    try {
      final repository = ref.read(patientLabRepositoryProvider);
      final response = await repository.verifyLabPayment({
        "booking_id": state.lastBookingId,
        "razorpay_order_id": orderId ?? state.lastOrderId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
      });

      if (response.data['success'] == true) {
        clearCart();
        state = state.copyWith(isPaymentLoading: false);
        AppLogger.success(
          'Lab payment verified, booking confirmed',
          tag: LogTags.patient, subTag: _subTag,
        );
      } else {
        state = state.copyWith(
          isPaymentLoading: false,
          paymentError: response.data['message'] ?? 'Verification failed',
        );
      }
    } catch (e, st) {
      state = state.copyWith(
        isPaymentLoading: false,
        paymentError: 'Payment verification failed',
      );
      AppLogger.exception(
        e, st,
        message: 'Lab payment verification failed',
        tag: LogTags.patient, subTag: _subTag,
      );
    }
  }

  void _handlePaymentFailure(String message) {
    state = state.copyWith(
      isPaymentLoading: false,
      paymentError: message,
    );
  }
}