import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/app_constants.dart';

class OtpCooldownNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void startCooldown([int seconds = AppConstants.otpResendCooldownSeconds]) {
    state = DateTime.now().add(Duration(seconds: seconds));
  }

  void reset() {
    state = null;
  }

  int get remainingSeconds {
    final expiry = state;
    if (expiry == null) return 0;
    final diff = expiry.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }
}

final otpCooldownProvider = NotifierProvider<OtpCooldownNotifier, DateTime?>(
  OtpCooldownNotifier.new,
);
