import 'package:dio/dio.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';

class ApiInterceptor extends Interceptor {
  static const String _subTag = 'ApiInterceptor';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info(
      '➡️ ${options.method} ${options.uri}',
      tag: LogTags.api,
      subTag: _subTag,
    );

    if (options.data != null) {
      AppLogger.json(
        options.data,
        tag: LogTags.api,
        subTag: _subTag,
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.success(
      '✅ ${response.statusCode} ${response.requestOptions.path}',
      tag: LogTags.api,
      subTag: _subTag,
    );

    // ✅ Print Map OR List responses
    if (response.data != null) {
      AppLogger.json(
        response.data,
        tag: LogTags.api,
        subTag: _subTag,
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '❌ ${err.requestOptions.method} ${err.requestOptions.path}',
      tag: LogTags.api,
      subTag: _subTag,
    );

    if (err.response?.data != null) {
      AppLogger.json(
        err.response?.data,
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