sealed class PaymentEvent {
  const PaymentEvent();
}

class PaymentInitiated extends PaymentEvent {
  final double amount;
  final String planName;
  const PaymentInitiated({required this.amount, required this.planName});
}

class PaymentProcessing extends PaymentEvent {
  const PaymentProcessing();
}

class PaymentSuccess extends PaymentEvent {
  final String? paymentId;
  final String? signature;
  const PaymentSuccess({this.paymentId, this.signature});
}

class PaymentFailed extends PaymentEvent {
  final String message;
  final bool retryable;
  const PaymentFailed({required this.message, this.retryable = true});
}