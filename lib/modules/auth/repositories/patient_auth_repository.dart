import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/network/dio_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:debug_bubble/debug_bubble.dart';
import 'package:yodoctor/core/utils/app_error_utils.dart';
import 'package:yodoctor/modules/auth/models/login_response.dart';
import 'package:yodoctor/modules/auth/models/otp_response.dart';
import 'package:yodoctor/core/storage/storage_service.dart';
import 'auth_repository.dart';

final patientAuthRepositoryProvider = Provider<PatientAuthRepository>((ref) {
  return PatientAuthRepository(
    dio: ref.read(dioProvider),
    storage: ref.read(storageProvider),
  );
});

class PatientAuthRepository implements AuthRepository {
  PatientAuthRepository({
    required Dio dio,
    required StorageService storage,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final StorageService _storage;

  static const String _subTag = 'PatientAuthRepository';

  @override
  Future<LoginResponse> signInWithEmail({
    required String identifier,
    required String password,
  }) async {
    try {
      DebugLog.info(
        'Starting patient email authentication process over network wire',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'identifier': identifier.trim(),
          'password': password,
          'portal': 'USER',
        },
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      final loginResponse = LoginResponse.fromJson(data);

      if (loginResponse.requiresOtp) {
        DebugLog.info(
          'Login requires OTP verification. VerificationId: ${loginResponse.verificationId}, Channel: ${loginResponse.channel}',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        return loginResponse;
      }

      if (!loginResponse.success) {
        DebugLog.warning(
          'Authentication rejected by gateway branch: ${loginResponse.message}',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        return loginResponse;
      }

      if (loginResponse.token?.isNotEmpty == true) {
        await _storage.saveToken(loginResponse.token!);
        await _storage.saveRole('patient');

        DebugLog.success(
          'Master JWT session key and patient role captured to secure local storage',
          tag: LogTags.auth,
          subTag: _subTag,
        );
      }

      DebugLog.success(
        'Patient identity context compiled and authenticated successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return loginResponse;
    } on DioException catch (e, st) {
      DebugLog.error(
        'Login API request transmission failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return LoginResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Unable to login. Please check your credentials.'),
      );
    } catch (e, st) {
      DebugLog.error(
        'Unexpected error during login mapping',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return LoginResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e),
      );
    }
  }

  /// Sends OTP for Login without password using /auth/login
  Future<LoginResponse> sendLoginOtp({
    required String identifier,
  }) async {
    try {
      DebugLog.info(
        'Sending patient login OTP request to /auth/login for identifier: $identifier',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      final payload = {
        'identifier': identifier.trim(),
        'password': '',
        'portal': 'USER',
        'loginWithOtp': true,
      };

      final response = await _dio.post(
        ApiConstants.login,
        data: payload,
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      final loginResponse = LoginResponse.fromJson(data);

      if (loginResponse.requiresOtp) {
        DebugLog.info(
          'Login OTP requested successfully. VerificationId: ${loginResponse.verificationId}, Channel: ${loginResponse.channel}, Destination: ${loginResponse.destination}',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        return loginResponse;
      }

      if (loginResponse.success && loginResponse.token?.isNotEmpty == true) {
        await _storage.saveToken(loginResponse.token!);
        await _storage.saveRole('patient');
      }

      return loginResponse;
    } on DioException catch (e, st) {
      DebugLog.error(
        'Send login OTP API request failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return LoginResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Unable to send OTP. Please try again.'),
      );
    } catch (e, st) {
      DebugLog.error(
        'Send login OTP failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return LoginResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e),
      );
    }
  }

  /// Verifies OTP for Login
  Future<LoginResponse> verifyLoginOtp({
    required String otp,
    String? verificationId,
    String? channel,
    String? mobile,
    String? email,
    String? identifier,
  }) async {
    try {
      DebugLog.info(
        'Submitting patient OTP verification request',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      final Map<String, dynamic> payload = {
        'otp': otp.trim(),
        if (channel != null && channel.isNotEmpty)
          'channel': channel.toUpperCase(),
        if (verificationId != null && verificationId.isNotEmpty)
          'verificationId': verificationId,
        if (mobile != null && mobile.isNotEmpty)
          'mobile': mobile,
        if (email != null && email.isNotEmpty)
          'email': email,
        if (identifier != null && identifier.isNotEmpty)
          'identifier': identifier,
        'portal': 'USER',
      };

      final response = await _dio.post(
        ApiConstants.verifyLoginOtp,
        data: payload,
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      final loginResponse = LoginResponse.fromJson(data);

      if (!loginResponse.success) {
        DebugLog.warning(
          'OTP verification rejected: ${loginResponse.message}',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        return loginResponse;
      }

      if (loginResponse.token?.isNotEmpty == true) {
        await _storage.saveToken(loginResponse.token!);
        await _storage.saveRole('patient');

        DebugLog.success(
          'Master JWT session key and patient role saved post OTP verification',
          tag: LogTags.auth,
          subTag: _subTag,
        );
      }

      return loginResponse;
    } on DioException catch (e, st) {
      DebugLog.error(
        'OTP verification API request failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return LoginResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Incorrect OTP. Please check the code and try again.'),
      );
    } catch (e, st) {
      DebugLog.error(
        'Unexpected error during OTP verification',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return LoginResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e),
      );
    }
  }

  // -------------------------------------------------------------
  // 📨 Patient Registration OTP APIs
  // -------------------------------------------------------------

  /// Send Registration Email OTP: POST /patient/register/send-email-otp
  Future<OtpSendResponse> sendRegistrationEmailOtp({
    required String email,
  }) async {
    try {
      DebugLog.info(
        'Sending registration email OTP to: $email',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      final response = await _dio.post(
        ApiConstants.patientRegisterSendEmailOtp,
        data: {
          'email': email.trim().toLowerCase(),
        },
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      return OtpSendResponse.fromJson(data);
    } on DioException catch (e, st) {
      DebugLog.error(
        'Send registration email OTP request failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return OtpSendResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Failed to send OTP to email. Please try again.'),
      );
    } catch (e, st) {
      DebugLog.error(
        'Send registration email OTP failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return OtpSendResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e),
      );
    }
  }

  /// Verify Registration Email OTP: POST /patient/register/verify-email-otp
  Future<OtpVerifyResponse> verifyRegistrationEmailOtp({
    required String email,
    required String otp,
    required String verificationId,
  }) async {
    try {
      DebugLog.info(
        'Verifying registration email OTP for: $email',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      final response = await _dio.post(
        ApiConstants.patientRegisterVerifyEmailOtp,
        data: {
          'email': email.trim().toLowerCase(),
          'otp': otp.trim(),
          'verificationId': verificationId.trim(),
        },
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      return OtpVerifyResponse.fromJson(data);
    } on DioException catch (e, st) {
      DebugLog.error(
        'Verify registration email OTP failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return OtpVerifyResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Incorrect OTP. Please check the code and try again.'),
      );
    } catch (e, st) {
      DebugLog.error(
        'Verify registration email OTP failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return OtpVerifyResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e),
      );
    }
  }

  /// Send Registration Mobile OTP: POST /patient/register/send-mobile-otp
  Future<OtpSendResponse> sendRegistrationMobileOtp({
    required String phone,
  }) async {
    try {
      DebugLog.info(
        'Sending registration mobile OTP to: $phone',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      final response = await _dio.post(
        ApiConstants.patientRegisterSendMobileOtp,
        data: {
          'phone': phone.trim(),
        },
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      return OtpSendResponse.fromJson(data);
    } on DioException catch (e, st) {
      DebugLog.error(
        'Send registration mobile OTP request failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return OtpSendResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Failed to send OTP to mobile number. Please try again.'),
      );
    } catch (e, st) {
      DebugLog.error(
        'Send registration mobile OTP failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return OtpSendResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e),
      );
    }
  }

  /// Verify Registration Mobile OTP: POST /patient/register/verify-mobile-otp
  Future<OtpVerifyResponse> verifyRegistrationMobileOtp({
    required String phone,
    required String otp,
    required String verificationId,
  }) async {
    try {
      DebugLog.info(
        'Verifying registration mobile OTP for: $phone',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      final response = await _dio.post(
        ApiConstants.patientRegisterVerifyMobileOtp,
        data: {
          'phone': phone.trim(),
          'otp': otp.trim(),
          'verificationId': verificationId.trim(),
        },
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      return OtpVerifyResponse.fromJson(data);
    } on DioException catch (e, st) {
      DebugLog.error(
        'Verify registration mobile OTP failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return OtpVerifyResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Incorrect OTP. Please check the code and try again.'),
      );
    } catch (e, st) {
      DebugLog.error(
        'Verify registration mobile OTP failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return OtpVerifyResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e),
      );
    }
  }

  /// Final registration submission
  Future<LoginResponse> signUpPatient({
    required String fullName,
    required String phone,
    String? email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String dob,
    String? emailVerificationId,
    String? mobileVerificationId,
  }) async {
    try {
      DebugLog.info(
        'Initiating network register request for new patient context',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      final Map<String, dynamic> payload = {
        'fullName': fullName.trim(),
        'phone': phone.trim(),
        if (email != null && email.trim().isNotEmpty)
          'email': email.trim().toLowerCase(),
        'password': password,
        'confirmPassword': confirmPassword,
        'gender': gender,
        'dob': dob,
        if (emailVerificationId != null && emailVerificationId.isNotEmpty)
          'emailVerificationId': emailVerificationId,
        if (mobileVerificationId != null && mobileVerificationId.isNotEmpty)
          'mobileVerificationId': mobileVerificationId,
      };

      final response = await _dio.post(
        ApiConstants.patientRegister,
        data: payload,
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);

      return LoginResponse(
        success: data['success'] ?? true,
        message: data['message'] ?? 'Patient registered successfully',
      );
    } on DioException catch (e, st) {
      DebugLog.error(
        'Registration pipeline rejected by gateway branch',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );

      return LoginResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Registration failed. Please try again.'),
      );
    } catch (e, st) {
      DebugLog.error(
        'Unexpected crash during register parser',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return LoginResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      DebugLog.info(
        'Initiating session cancellation request',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      await _storage.clearAll();

      DebugLog.success(
        'Local token session and role blocks flushed cleanly',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    } catch (e, st) {
      DebugLog.error(
        'Failed to clear local token vectors cleanly',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<LoginResponse> signInWithGoogle({
    required String firebaseToken,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.googleLogin,
        data: {
          'token': firebaseToken,
          'portal': 'USER',
        },
      );

      final loginResponse = LoginResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      if (loginResponse.success &&
          loginResponse.token?.isNotEmpty == true) {
        await _storage.saveToken(loginResponse.token!);
        await _storage.saveRole('patient');
      }

      return loginResponse;
    } on DioException catch (e, st) {
      DebugLog.error(
        'Google login failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return LoginResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e, fallbackMessage: 'Google login failed. Please try again.'),
      );
    } catch (e, st) {
      DebugLog.error(
        'Google login failed',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
      return LoginResponse(
        success: false,
        message: AppErrorUtils.getFriendlyMessage(e),
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getUserRole() async {
    return _storage.getRole();
  }
}