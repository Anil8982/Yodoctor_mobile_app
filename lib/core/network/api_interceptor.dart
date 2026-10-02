import 'package:dio/dio.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';

class ApiInterceptor extends Interceptor {
  static const String _subTag = 'ApiInterceptor';

  static const Set<String> _sensitiveKeys = {
    'token',
    'accessToken',
    'access_token',
    'refreshToken',
    'refresh_token',
    'firebaseToken',
    'firebase_token',
    'authorization',
    'password',
    'confirmPassword',
    'confirm_password',
  };

  dynamic _sanitizeForLog(dynamic data) {
    if (data is Map) {
      return data.map(
            (key, value) {
          if (_sensitiveKeys.contains(key.toString())) {
            return MapEntry(key, '****** 🤫 sensitive data ******');
          }

          return MapEntry(
            key,
            _sanitizeForLog(value),
          );
        },
      );
    }

    if (data is List) {
      return data.map(_sanitizeForLog).toList();
    }

    return data;
  }

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    AppLogger.info(
      '➡️ ${options.method} ${options.uri}',
      tag: LogTags.api,
      subTag: _subTag,
    );

    if (options.data != null) {
      AppLogger.json(
        _sanitizeForLog(options.data),
        tag: LogTags.api,
        subTag: _subTag,
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {
    AppLogger.success(
      '✅ ${response.statusCode} ${response.requestOptions.path}',
      tag: LogTags.api,
      subTag: _subTag,
    );

    if (response.data != null) {
      if (response.requestOptions.responseType == ResponseType.bytes) {
        final size = response.data is List<int>
            ? (response.data as List<int>).length
            : 0;

        AppLogger.info(
          '📥 File Download ($size bytes)',
          tag: LogTags.api,
          subTag: _subTag,
        );
      } else {
        AppLogger.json(
          _sanitizeForLog(response.data),
          tag: LogTags.api,
          subTag: _subTag,
        );
      }
    }

    handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    AppLogger.error(
      '❌ ${err.requestOptions.method} ${err.requestOptions.path}',
      tag: LogTags.api,
      subTag: _subTag,
    );

    if (err.response?.data != null) {
      AppLogger.json(
        _sanitizeForLog(err.response?.data),
        tag: LogTags.api,
        subTag: 'ErrorResponse',
      );
    }

    AppLogger.exception(
      err,
      err.stackTrace,
      message: 'API Error',
      tag: LogTags.api,
      subTag: _subTag,
    );

    handler.next(err);
  }
}