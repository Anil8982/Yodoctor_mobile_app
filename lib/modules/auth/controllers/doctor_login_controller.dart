import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/providers/app_role_provider.dart';
import 'package:yodoctor/modules/auth/repository/doctor_auth_repository.dart';

import 'doctor_status_controller.dart';

final doctorLoginControllerProvider =
    AsyncNotifierProvider<DoctorLoginController, Map<String, dynamic>?>(
      DoctorLoginController.new,
    );

class DoctorLoginController extends AsyncNotifier<Map<String, dynamic>?> {
  static const String _subTag = 'DoctorLoginController';

  @override
  FutureOr<Map<String, dynamic>?> build() => null;

  Future<Map<String, dynamic>?> login({
    required String identifier,
    required String password,
  }) async {
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

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(doctorAuthRepositoryProvider);
      await repository.clearAuthSession();

      // Clear old doctor's runtime verification state
      ref.read(doctorStatusProvider.notifier).reset();

      ref.read(appRoleProvider.notifier).clearRole();
      state = const AsyncData(null);
      AppLogger.success(
        'Doctor control profile session tokens terminated successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    } catch (e, st) {
      state = AsyncError(e, st);
      AppLogger.exception(
        e,
        st,
        message: 'Session clear failure sequence intercept',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    }
  }
}
