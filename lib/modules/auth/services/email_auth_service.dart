import 'package:dio/dio.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/models/auth/login_response.dart';
import 'package:yodoctor/core/storage/storage_service.dart';
import 'auth_service.dart';

class EmailAuthService implements AuthService {
  EmailAuthService({
    required Dio dio,
    required StorageService storage,
  }) : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final StorageService _storage;

  static const String _subTag = 'EmailAuthService';

  @override
  Future<LoginResponse> signInWithEmail({
    required String identifier,
    required String password,
  }) async {
    try {
      AppLogger.info(
        'Starting email authentication',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'identifier': identifier.trim(),
          'password': password,
        },
      );

      final Map<String, dynamic> data =
      Map<String, dynamic>.from(response.data);

      final loginResponse = LoginResponse.fromJson(data);

      if (!loginResponse.success) {
        AppLogger.warning(
          loginResponse.message,
          tag: LogTags.auth,
          subTag: _subTag,
        );

        return loginResponse;
      }

      if (loginResponse.token?.isNotEmpty == true) {
        await _storage.saveToken(loginResponse.token!);

        AppLogger.success(
          'JWT token saved successfully',
          tag: LogTags.auth,
          subTag: _subTag,
        );
      }

      AppLogger.success(
        'User authenticated successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return loginResponse;
    } on DioException catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Login API request failed',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      String errorMessage =
          'Unable to login. Please try again.';

      final responseData = e.response?.data;

      if (responseData is Map<String, dynamic>) {
        errorMessage =
            responseData['message']?.toString() ??
                errorMessage;
      }

      return LoginResponse(
        success: false,
        message: errorMessage,
      );
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Unexpected login error',
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
      await _storage.clearToken();

      AppLogger.success(
        'Local session cleared',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Failed to clear local session',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      rethrow;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = _storage.getToken();

    return token != null && token.isNotEmpty;
  }
}