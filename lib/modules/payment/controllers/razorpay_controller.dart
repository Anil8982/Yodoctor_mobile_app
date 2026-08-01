import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';

/// Events emitted by RazorpayController
sealed class RazorpayEvent {
  const RazorpayEvent();
}

class RazorpaySuccess extends RazorpayEvent {
  final String? paymentId;
  final String? orderId;
  final String? signature;

  const RazorpaySuccess({
    this.paymentId,
    this.orderId,
    this.signature,
  });
}

class RazorpayFailure extends RazorpayEvent {
  final int code;
  final String message;

  const RazorpayFailure({
    required this.code,
    required this.message,
  });
}

class RazorpayCancelled extends RazorpayEvent {
  const RazorpayCancelled();
}

class RazorpayExternalWallet extends RazorpayEvent {
  final String walletName;

  const RazorpayExternalWallet({required this.walletName});
}

/// RazorpayController - Handles only Razorpay SDK interactions
class RazorpayController {
  static const String _tag = 'RazorpayController';

  late final Razorpay _razorpay;
  bool _isCheckoutOpen = false;
  final StreamController<RazorpayEvent> _eventController =
  StreamController<RazorpayEvent>.broadcast();

  /// Stream of Razorpay events for external listeners
  Stream<RazorpayEvent> get events => _eventController.stream;

  /// Check if payment sheet is currently open
  bool get isCheckoutOpen => _isCheckoutOpen;

  RazorpayController() {
    _razorpay = Razorpay();
    _registerListeners();

    AppLogger.info(
      'RazorpayController Initialized',
      tag: LogTags.razorpay,
      subTag: _tag,
    );
  }

  void _registerListeners() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  /// Open Razorpay checkout for subscription
  void openSubscriptionCheckout({
    required String key,
    required String subscriptionId,
    required String planName,
    Map<String, String> prefill = const {},
  }) {
    if (_isCheckoutOpen) {
      AppLogger.warning(
        'Checkout already open, ignoring duplicate call',
        tag: LogTags.razorpay,
        subTag: _tag,
      );
      return;
    }

    _isCheckoutOpen = true;

    try {
      final options = {
        'key': key,
        'subscription_id': subscriptionId,
        'name': 'YoDoctor',
        'description': planName,
        'retry': {'enabled': true, 'max_count': 1},
        'prefill': {
          'contact': prefill['contact'] ?? '',
          'email': prefill['email'] ?? '',
          'name': prefill['name'] ?? '',
        },
        'send_sms_hash': true,
      };

      AppLogger.info(
        'Opening Razorpay checkout for subscription: $subscriptionId',
        tag: LogTags.razorpay,
        subTag: _tag,
      );

      _razorpay.open(options);
    } catch (e, st) {
      _isCheckoutOpen = false;

      AppLogger.exception(
        e,
        st,
        message: 'Failed to open Razorpay checkout',
        tag: LogTags.razorpay,
        subTag: _tag,
      );

      _eventController.add(
        RazorpayFailure(code: -1, message: 'Failed to open payment gateway'),
      );
    }
  }

  /// Open Razorpay checkout for orders (lab tests, home care, etc.)
  void openOrderCheckout({
    required String key,
    required String orderId,
    required double amount,
    required String description,
    Map<String, String> prefill = const {},
  }) {
    if (_isCheckoutOpen) {
      AppLogger.warning(
        'Checkout already open, ignoring duplicate call',
        tag: LogTags.razorpay,
        subTag: _tag,
      );
      return;
    }

    _isCheckoutOpen = true;

    try {
      final options = {
        'key': key,
        'order_id': orderId,
        'name': 'YoDoctor',
        'description': description,
        'amount': (amount * 100).toInt(), // rupees to paise
        'prefill': {
          'contact': prefill['contact'] ?? '',
          'email': prefill['email'] ?? '',
          'name': prefill['name'] ?? '',
        },
      };

      AppLogger.info(
        'Opening Razorpay checkout for order: $orderId, amount: ₹$amount',
        tag: LogTags.razorpay,
        subTag: _tag,
      );

      _razorpay.open(options);
    } catch (e, st) {
      _isCheckoutOpen = false;

      AppLogger.exception(
        e,
        st,
        message: 'Failed to open Razorpay order checkout',
        tag: LogTags.razorpay,
        subTag: _tag,
      );

      _eventController.add(
        RazorpayFailure(code: -1, message: 'Failed to open payment gateway'),
      );
    }
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) {
    _isCheckoutOpen = false;

    AppLogger.success(
      'Razorpay Payment Success: ${response.paymentId}',
      tag: LogTags.razorpay,
      subTag: _tag,
    );

    _eventController.add(
      RazorpaySuccess(
        paymentId: response.paymentId,
        orderId: response.orderId,
        signature: response.signature,
      ),
    );
  }

  void _onPaymentError(PaymentFailureResponse response) {
    _isCheckoutOpen = false;

    final errorCode = response.code ?? 0;

    AppLogger.error(
      'Razorpay Payment Failed - Code: $errorCode, '
          'Message: ${response.message}, Error: ${response.error}',
      tag: LogTags.razorpay,
      subTag: _tag,
    );

    if (errorCode == Razorpay.PAYMENT_CANCELLED) {
      _eventController.add(const RazorpayCancelled());
    } else {
      _eventController.add(
        RazorpayFailure(
          code: errorCode,
          message: response.message ?? 'Payment failed',
        ),
      );
    }
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    _isCheckoutOpen = false;

    AppLogger.info(
      'External Wallet Selected: ${response.walletName}',
      tag: LogTags.razorpay,
      subTag: _tag,
    );

    _eventController.add(
      RazorpayExternalWallet(walletName: response.walletName ?? 'Unknown'),
    );
  }

  /// Clean up resources
  void dispose() {
    _razorpay.clear();
    _eventController.close();

    AppLogger.info(
      'RazorpayController Disposed',
      tag: LogTags.razorpay,
      subTag: _tag,
    );
  }
}

/// Riverpod provider for RazorpayController
final razorpayControllerProvider = Provider<RazorpayController>((ref) {
  final controller = RazorpayController();
  ref.onDispose(() => controller.dispose());
  return controller;
});