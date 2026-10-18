import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/providers/otp_cooldown_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/core/session/app_session_controller.dart';
import 'package:yodoctor/core/utils/app_error_utils.dart';
import 'package:yodoctor/modules/auth/repositories/doctor_auth_repository.dart';

final doctorLoginControllerProvider =
    AsyncNotifierProvider<DoctorLoginController, Map<String, dynamic>?>(
      DoctorLoginController.new,
    );

class DoctorLoginController extends AsyncNotifier<Map<String, dynamic>?> {
  static const String _subTag = 'DoctorLoginController';

  Map<String, dynamic>? _pendingOtpPayload;
  String? _pendingIdentifier;

  @override
  FutureOr<Map<String, dynamic>?> build() => null;

  /// Handles traditional Doctor Email/Phone + Password Normal Sign-In
  Future<Map<String, dynamic>?> login({
    required String identifier,
    required String password,
  }) async {
    _pendingIdentifier = null;
    _pendingOtpPayload = null;
    ref.read(otpCooldownProvider.notifier).reset();

    AppLogger.info(
      'Initiating doctor normal password authentication',
      tag: LogTags.auth,
      subTag: _subTag,
    );
    state = const AsyncLoading();

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final response = await repository.login(
        identifier: identifier,
        password: password,
      );
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final data = response.data;
        final redirect = data["redirect"];
        final token = data["data"]?["token"] ?? data["token"];

        final bool requiresOtp = data["requiresOtp"] == true ||
            data["otpRequired"] == true ||
            data["isOtpRequired"] == true ||
            data["data"]?["requiresOtp"] == true ||
            data["data"]?["otpRequired"] == true ||
            redirect == "otp" ||
            data["status"] == "OTP_REQUIRED" ||
            (token == null &&
                (data["verificationId"] != null ||
                    data["data"]?["verificationId"] != null));

        if (requiresOtp) {
          _pendingIdentifier = identifier.trim().toLowerCase();
          final otpPayload = {
            "redirect": "otp",
            "requiresOtp": true,
            "verificationId":
                data["verificationId"] ?? data["data"]?["verificationId"],
            "channel": data["channel"] ?? data["data"]?["channel"],
            "mobile": data["mobile"] ?? data["data"]?["mobile"],
            "maskedDestination": data["maskedEmail"] ??
                data["data"]?["maskedEmail"] ??
                data["maskedMobile"] ??
                data["data"]?["maskedMobile"] ??
                data["maskedDestination"] ??
                data["data"]?["maskedDestination"] ??
                identifier,
            "message": data["message"] ?? "OTP sent successfully",
          };
          _pendingOtpPayload = otpPayload;
          ref.read(otpCooldownProvider.notifier).startCooldown();
          state = AsyncData(otpPayload);
          return otpPayload;
        }

        if (token != null) {
          final status = data["status"] ?? data["data"]?["status"];

          AppLogger.info(
            'Doctor login API Response Status: $status',
            tag: LogTags.auth,
            subTag: _subTag,
          );

          if (redirect == "resume") {
            await repository.saveRegistrationToken(token);
          } else {
            await repository.saveSessionToken(token);
            await repository.saveUserRole('doctor');
            if (status != null) {
              await repository.saveStatus(status.toString());
            }

            final storage = ref.read(storageProvider);
            await storage.saveActiveSubscription(false);

            ref.read(appRoleProvider.notifier).setRole(AppRole.doctor);
          }
        }

        _pendingOtpPayload = null;
        _pendingIdentifier = null;
        ref.read(otpCooldownProvider.notifier).reset();

        final redirectPayload = {
          "redirect": data["redirect"],
          "status": data["status"],
          "nextStep": data["nextStep"],
          "message": data["message"],
        };

        state = AsyncData(redirectPayload);
        return redirectPayload;
      } else {
        final msg = response.data?["message"] ?? "Authentication Rejected";
        state = AsyncError(AppErrorUtils.sanitizeErrorMessage(msg), StackTrace.current);
        return null;
      }
    } catch (e, st) {
      final message = AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Unable to login. Please check your credentials.');
      state = AsyncError(message, st);

      AppLogger.exception(
        e,
        st,
        message: 'Doctor login exception',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return null;
    }
  }

  /// Sends OTP for Doctor Login without password
  Future<Map<String, dynamic>?> sendLoginOtp({
    required String identifier,
  }) async {
    final cleanId = identifier.trim().toLowerCase();
    if (_pendingIdentifier != null && _pendingIdentifier != cleanId) {
      _pendingOtpPayload = null;
      ref.read(otpCooldownProvider.notifier).reset();
    }
    _pendingIdentifier = cleanId;

    final remaining = ref.read(otpCooldownProvider.notifier).remainingSeconds;
    if (remaining > 0 && _pendingOtpPayload != null) {
      AppLogger.info(
        'Active doctor OTP cooldown running (${remaining}s remaining). Returning cached pending OTP state.',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      return _pendingOtpPayload;
    }

    AppLogger.info(
      'Initiating doctor send login OTP for: $cleanId',
      tag: LogTags.auth,
      subTag: _subTag,
    );
    state = const AsyncLoading();

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final response = await repository.sendLoginOtp(identifier: identifier);
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final data = response.data;
        final redirect = data["redirect"];
        final token = data["data"]?["token"] ?? data["token"];

        final bool requiresOtp = data["requiresOtp"] == true ||
            data["otpRequired"] == true ||
            data["isOtpRequired"] == true ||
            data["data"]?["requiresOtp"] == true ||
            data["data"]?["otpRequired"] == true ||
            redirect == "otp" ||
            data["status"] == "OTP_REQUIRED" ||
            (token == null &&
                (data["verificationId"] != null ||
                    data["data"]?["verificationId"] != null));

        if (requiresOtp) {
          final otpPayload = {
            "redirect": "otp",
            "requiresOtp": true,
            "verificationId":
                data["verificationId"] ?? data["data"]?["verificationId"],
            "channel": data["channel"] ?? data["data"]?["channel"],
            "mobile": data["mobile"] ?? data["data"]?["mobile"],
            "maskedDestination": data["destination"] ??
                data["data"]?["destination"] ??
                data["maskedEmail"] ??
                data["data"]?["maskedEmail"] ??
                data["maskedMobile"] ??
                data["data"]?["maskedMobile"] ??
                data["maskedDestination"] ??
                data["data"]?["maskedDestination"] ??
                identifier,
            "expiresIn": data["expiresIn"] ?? data["data"]?["expiresIn"],
            "message": data["message"] ?? "OTP sent successfully",
          };

          _pendingOtpPayload = otpPayload;
          ref.read(otpCooldownProvider.notifier).startCooldown();
          state = AsyncData(otpPayload);
          return otpPayload;
        }

        if (token != null) {
          final status = data["status"] ?? data["data"]?["status"];

          if (redirect == "resume") {
            await repository.saveRegistrationToken(token);
          } else {
            await repository.saveSessionToken(token);
            await repository.saveUserRole('doctor');
            if (status != null) {
              await repository.saveStatus(status.toString());
            }

            final storage = ref.read(storageProvider);
            await storage.saveActiveSubscription(false);

            ref.read(appRoleProvider.notifier).setRole(AppRole.doctor);
          }

          _pendingOtpPayload = null;
          _pendingIdentifier = null;
          ref.read(otpCooldownProvider.notifier).reset();

          final redirectPayload = {
            "redirect": data["redirect"],
            "status": data["status"],
            "nextStep": data["nextStep"],
            "message": data["message"],
          };

          state = AsyncData(redirectPayload);
          return redirectPayload;
        }

        final msg = response.data?["message"] ?? "Failed to send OTP";
        state = AsyncError(AppErrorUtils.sanitizeErrorMessage(msg), StackTrace.current);
        return null;
      } else {
        final msg = response.data?["message"] ?? "Failed to send OTP";
        state = AsyncError(AppErrorUtils.sanitizeErrorMessage(msg), StackTrace.current);
        return null;
      }
    } catch (e, st) {
      final message = AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Failed to send OTP. Please try again.');
      state = AsyncError(message, st);

      AppLogger.exception(
        e,
        st,
        message: 'Doctor send login OTP exception',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return null;
    }
  }

  /// Verifies OTP for Doctor login
  Future<Map<String, dynamic>?> verifyOtp({
    required String otp,
    String? verificationId,
    String? channel,
    String? mobile,
    String? email,
    String? identifier,
  }) async {
    AppLogger.info(
      'Initiating doctor OTP verification sequence',
      tag: LogTags.auth,
      subTag: _subTag,
    );
    state = const AsyncLoading();

    try {
      final effectiveVerificationId = verificationId ?? _pendingOtpPayload?['verificationId'];
      final effectiveChannel = channel ?? _pendingOtpPayload?['channel'];
      final effectiveMobile = mobile ?? _pendingOtpPayload?['mobile'];

      final repository = ref.read(doctorAuthRepositoryProvider);
      final response = await repository.verifyLoginOtp(
        otp: otp,
        verificationId: effectiveVerificationId,
        channel: effectiveChannel,
        mobile: effectiveMobile,
        email: email,
        identifier: identifier,
      );
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final data = response.data;
        final redirect = data["redirect"];
        final token = data["data"]?["token"] ?? data["token"];

        if (token != null) {
          final status = data["status"] ?? data["data"]?["status"];

          if (redirect == "resume") {
            await repository.saveRegistrationToken(token);
          } else {
            await repository.saveSessionToken(token);
            await repository.saveUserRole('doctor');
            if (status != null) {
              await repository.saveStatus(status.toString());
            }

            final storage = ref.read(storageProvider);
            await storage.saveActiveSubscription(false);

            ref.read(appRoleProvider.notifier).setRole(AppRole.doctor);
          }
        }

        _pendingOtpPayload = null;
        ref.read(otpCooldownProvider.notifier).reset();

        final redirectPayload = {
          "redirect": data["redirect"],
          "status": data["status"],
          "nextStep": data["nextStep"],
          "message": data["message"],
        };

        state = AsyncData(redirectPayload);
        return redirectPayload;
      } else {
        final msg = response.data?["message"] ?? "Incorrect OTP. Please check the code and try again.";
        state = AsyncError(AppErrorUtils.sanitizeErrorMessage(msg), StackTrace.current);
        return null;
      }
    } catch (e, st) {
      final message = AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Incorrect OTP. Please check the code and try again.');
      state = AsyncError(message, st);

      AppLogger.exception(
        e,
        st,
        message: 'Doctor OTP verification exception',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return null;
    }
  }

  /// Resends OTP
  Future<Map<String, dynamic>?> resendOtp({
    required String identifier,
    String? password,
  }) async {
    AppLogger.info(
      'Initiating doctor OTP resend sequence for: $identifier',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final response = (password != null && password.isNotEmpty)
          ? await repository.login(
              identifier: identifier,
              password: password,
            )
          : await repository.sendLoginOtp(identifier: identifier);

      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        final data = response.data;
        _pendingOtpPayload = {
          "redirect": "otp",
          "requiresOtp": true,
          "verificationId": data["verificationId"] ??
              data["data"]?["verificationId"] ??
              _pendingOtpPayload?["verificationId"],
          "channel": data["channel"] ??
              data["data"]?["channel"] ??
              _pendingOtpPayload?["channel"],
          "mobile": data["mobile"] ??
              data["data"]?["mobile"] ??
              _pendingOtpPayload?["mobile"],
          "maskedDestination": _pendingOtpPayload?["maskedDestination"] ?? identifier,
          "message": data["message"] ?? "OTP resent successfully",
        };
        ref.read(otpCooldownProvider.notifier).startCooldown();

        return {
          "success": true,
          "message": data["message"] ?? "OTP resent successfully",
          "verificationId": _pendingOtpPayload!["verificationId"],
          "channel": _pendingOtpPayload!["channel"],
          "mobile": _pendingOtpPayload!["mobile"],
        };
      } else {
        return {
          "success": false,
          "message": AppErrorUtils.sanitizeErrorMessage(
            response.data?["message"]?.toString() ?? "Failed to resend OTP",
          ),
        };
      }
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Doctor OTP resend failed',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      return {
        "success": false,
        "message": AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Failed to resend OTP. Please try again.'),
      };
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      _pendingOtpPayload = null;
      ref.read(otpCooldownProvider.notifier).reset();
      await ref.read(appSessionProvider).logout(AppRole.doctor);

      state = const AsyncData(null);

      AppLogger.success(
        'Doctor logout completed successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    } catch (e, st) {
      state = AsyncError(AppErrorUtils.getFriendlyMessage(e), st);

      AppLogger.exception(
        e,
        st,
        message: 'Doctor logout failed',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    }
  }
}
