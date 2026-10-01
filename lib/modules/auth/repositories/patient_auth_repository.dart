import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/network/dio_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/modules/auth/models/login_response.dart';
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
      AppLogger.info(
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
        AppLogger.info(
          'Login requires OTP verification. VerificationId: ${loginResponse.verificationId}, Channel: ${loginResponse.channel}',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        return loginResponse;
      }

      if (!loginResponse.success) {
        AppLogger.warning(
          'Authentication rejected by gateway branch: ${loginResponse.message}',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        return loginResponse;
      }

      if (loginResponse.token?.isNotEmpty == true) {
        await _storage.saveToken(loginResponse.token!);
        await _storage.saveRole('patient');

        AppLogger.success(
          'Master JWT session key and patient role captured to secure local storage',
          tag: LogTags.auth,
          subTag: _subTag,
        );
      }

      AppLogger.success(
        'Patient identity context compiled and authenticated successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return loginResponse;
    } on DioException catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Login API request transmission failed completely',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      String errorMessage = 'Unable to login. Please try again.';
      final responseData = e.response?.data;

      if (responseData is Map<String, dynamic>) {
        errorMessage = responseData['message']?.toString() ?? errorMessage;
      }

      return LoginResponse(
        success: false,
        message: errorMessage,
      );
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Unexpected run-time panic during login mapping cycle',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return LoginResponse(
        success: false,
        message: 'Something went wrong.',
      );
    }
  }

  Future<LoginResponse> verifyLoginOtp({
    required String otp,
    String? verificationId,
    String? channel,
    String? mobile,
  }) async {
    try {
      AppLogger.info(
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
      };

      final response = await _dio.post(
        ApiConstants.verifyLoginOtp,
        data: payload,
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      final loginResponse = LoginResponse.fromJson(data);

      if (!loginResponse.success) {
        AppLogger.warning(
          'OTP verification rejected by gateway branch: ${loginResponse.message}',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        return loginResponse;
      }

      if (loginResponse.token?.isNotEmpty == true) {
        await _storage.saveToken(loginResponse.token!);
        await _storage.saveRole('patient');

        AppLogger.success(
          'Master JWT session key and patient role saved post OTP verification',
          tag: LogTags.auth,
          subTag: _subTag,
        );
      }

      return loginResponse;
    } on DioException catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'OTP verification API request failed',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      String errorMessage = 'Invalid or expired OTP. Please try again.';
      final responseData = e.response?.data;

      if (responseData is Map<String, dynamic>) {
        errorMessage = responseData['message']?.toString() ?? errorMessage;
      }

      return LoginResponse(
        success: false,
        message: errorMessage,
      );
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Unexpected error during OTP verification',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return LoginResponse(
        success: false,
        message: 'Something went wrong during OTP verification.',
      );
    }
  }

  Future<LoginResponse> signUpPatient({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String dob,
  }) async {
    try {
      AppLogger.info(
        'Initiating network register request for new patient context',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      final response = await _dio.post(
        ApiConstants.patientRegister,
        data: {
          'fullName': fullName.trim(),
          'phone': phone.trim(),
          'email': email.trim(),
          'password': password,
          'confirmPassword': confirmPassword,
          'gender': gender,
          'dob': dob,
        },
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);

      return LoginResponse(
        success: data['success'] ?? true,
        message: data['message'] ?? 'Patient registered successfully',
      );
    } on DioException catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Registration pipeline rejected by gateway branch',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      String errorMessage = 'Registration failed. Please try again.';
      final responseData = e.response?.data;

      if (responseData is Map<String, dynamic>) {
        errorMessage = responseData['message']?.toString() ?? errorMessage;
      }

      return LoginResponse(
        success: false,
        message: errorMessage,
      );
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Unexpected structural dynamic crash during register parser',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      return LoginResponse(
        success: false,
        message: 'Something went wrong.',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      AppLogger.info(
        'Initiating session cancellation request',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      await _storage.clearAll();

      AppLogger.success(
        'Local token session and role blocks flushed cleanly',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Failed to clear local token vectors cleanly',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      rethrow;
    }
  }


  Future<LoginResponse> signInWithGoogle({
    required String firebaseToken,
  }) async {
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