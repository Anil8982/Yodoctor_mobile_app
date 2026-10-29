import 'package:debug_bubble/debug_bubble.dart';
import 'package:dio/dio.dart';
import 'package:yodoctor/core/constants/log_tags.dart';

class ApiInterceptor extends Interceptor {
  static const String _subTag = 'ApiInterceptor';

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    DebugLog.info(
      '➡️ ${options.method} ${options.uri}',
      tag: LogTags.api,
      subTag: _subTag,
      json: options.data,
    );

    handler.next(options);
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {
    if (response.requestOptions.responseType == ResponseType.bytes) {
      final size = response.data is List<int>
          ? (response.data as List<int>).length
          : 0;

      DebugLog.info(
        '📥 File Download ($size bytes)',
        tag: LogTags.api,
        subTag: _subTag,
        metadata: {'statusCode': response.statusCode},
      );
    } else {
      DebugLog.success(
        '✅ ${response.statusCode} ${response.requestOptions.path}',
        tag: LogTags.api,
        subTag: _subTag,
        json: response.data,
      );
    }

    handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    final statusCode = err.response?.statusCode;
    final method = err.requestOptions.method;
    final path = err.requestOptions.path;

    final serverMessage = err.response?.data is Map
        ? (err.response?.data['message'] ?? err.message)
        : err.message;

    if (statusCode == 404) {
      DebugLog.info(
        'ℹ️ $method $path (404 Not Found)',
        tag: LogTags.api,
        subTag: _subTag,
        error: serverMessage,
        json: err.response?.data,
      );
    } else if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      DebugLog.warning(
        '⚠️ $method $path ($statusCode)',
        tag: LogTags.api,
        subTag: _subTag,
        error: serverMessage,
        json: err.response?.data,
      );
    } else {
      DebugLog.error(
        '❌ $method $path (${statusCode ?? 'NETWORK_FAIL'})',
        tag: LogTags.api,
        subTag: _subTag,
        error: serverMessage,
        stackTrace: err.stackTrace,
        json: err.response?.data,
      );
    }

    handler.next(err);
  }
}