import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/core/providers/otp_cooldown_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/core/session/app_session_controller.dart';
import 'package:yodoctor/modules/auth/repositories/doctor_auth_repository.dart';

final doctorLoginControllerProvider =
    AsyncNotifierProvider<DoctorLoginController, Map<String, dynamic>?>(
      DoctorLoginController.new,
    );

class DoctorLoginController extends AsyncNotifier<Map<String, dynamic>?> {
  static const String _subTag = 'DoctorLoginController';

  Map<String, dynamic>? _pendingOtpPayload;

  @override
  FutureOr<Map<String, dynamic>?> build() => null;

  Future<Map<String, dynamic>?> login({
    required String identifier,
    required String password,
  }) async {
    // 🛡️ Cooldown Guard: Prevent new network OTP triggers during active cooldown
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
      'Initiating doctor email credential verification sequence',
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
        final token = data["data"]?["token"];

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
            "maskedDestination": data["maskedEmail"] ??
                data["data"]?["maskedEmail"] ??
                data["maskedMobile"] ??
                data["data"]?["maskedMobile"] ??
                data["maskedDestination"] ??
                data["data"]?["maskedDestination"],
            "message": data["message"],
          };
          _pendingOtpPayload = otpPayload;
          ref.read(otpCooldownProvider.notifier).startCooldown();
          state = AsyncData(otpPayload);
          return otpPayload;
        }

        if (token != null) {
          final status = data["status"];

          AppLogger.info(
            'Login API Response Status: $status',
            tag: LogTags.auth,
            subTag: _subTag,
          );

          if (redirect == "resume") {
            await repository.saveRegistrationToken(token);

            AppLogger.success(
              'Temporary Registration Token captured',
              tag: LogTags.auth,
              subTag: _subTag,
            );
          } else {
            await repository.saveSessionToken(token);
            await repository.saveUserRole('doctor');
            await repository.saveStatus(status);

            final storage = ref.read(storageProvider);
            await storage.saveActiveSubscription(false);

            ref.read(appRoleProvider.notifier).setRole(AppRole.doctor);

            if (status == "APPROVED") {
              AppLogger.success(
                'JWT Master active session token and role cached',
                tag: LogTags.auth,
                subTag: _subTag,
              );
            } else {
              AppLogger.warning(
                'Login allowed but account status is: $status',
                tag: LogTags.auth,
                subTag: _subTag,
              );
            }
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
        final msg = response.data?["message"] ?? "Authentication Rejected";
        state = AsyncError(msg, StackTrace.current);
        return null;
      }
    } catch (e, st) {
      String message = 'Something went wrong';

      if (e is DioException) {
        final statusCode = e.response?.statusCode;

        if (statusCode == 401) {
          message = e.response?.data?['message'] ?? 'Invalid email or password';
        } else if (statusCode == 404) {
          message = 'Account not found';
        } else if (statusCode == 500) {
          message = 'Server error. Please try again later';
        } else {
          message = e.response?.data?['message'] ?? 'Request failed';
        }
      }

      state = AsyncError(message, st);

      AppLogger.exception(
        e,
        st,
        message: 'Fatal crash within session gate login wire',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return null;
    }
  }

  Future<Map<String, dynamic>?> verifyOtp({
    required String otp,
    String? verificationId,
    String? channel,
    String? mobile,
  }) async {
    AppLogger.info(
      'Initiating doctor OTP verification sequence',
      tag: LogTags.auth,
      subTag: _subTag,
    );
    state = const AsyncLoading();

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final response = await repository.verifyLoginOtp(
        otp: otp,
        verificationId: verificationId,
        channel: channel,
        mobile: mobile,
      );
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final data = response.data;
        final redirect = data["redirect"];
        final token = data["data"]?["token"];

        if (token != null) {
          final status = data["status"];

          if (redirect == "resume") {
            await repository.saveRegistrationToken(token);
          } else {
            await repository.saveSessionToken(token);
            await repository.saveUserRole('doctor');
            await repository.saveStatus(status);

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
        final msg = response.data?["message"] ?? "OTP Verification Failed";
        state = AsyncError(msg, StackTrace.current);
        return null;
      }
    } catch (e, st) {
      String message = 'OTP verification failed';

      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400 || statusCode == 401) {
          message = e.response?.data?['message'] ?? 'Invalid or expired OTP';
        } else if (statusCode == 404) {
          message = 'Account or verification request not found';
        } else if (statusCode == 500) {
          message = 'Server error. Please try again later';
        } else {
          message = e.response?.data?['message'] ?? 'Verification failed';
        }
      }

      state = AsyncError(message, st);

      AppLogger.exception(
        e,
        st,
        message: 'Fatal crash within doctor OTP verification wire',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return null;
    }
  }

  Future<Map<String, dynamic>?> resendOtp({
    required String identifier,
    required String password,
  }) async {
    AppLogger.info(
      'Initiating doctor OTP resend sequence',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      final response = await repository.login(
        identifier: identifier,
        password: password,
      );

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
          "maskedDestination": _pendingOtpPayload?["maskedDestination"],
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
          "message": response.data?["message"] ?? "Failed to resend OTP",
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
      String message = 'Failed to resend OTP';
      if (e is DioException) {
        message = e.response?.data?['message'] ?? message;
      }
      return {
        "success": false,
        "message": message,
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
      state = AsyncError(e, st);

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
