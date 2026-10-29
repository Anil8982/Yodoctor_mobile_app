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
        json: response.data, // रेडॅक्शन आपोआप होते
      );
    }

    handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    DebugLog.error(
      '❌ ${err.requestOptions.method} ${err.requestOptions.path} (${err.response?.statusCode ?? 'NO_STATUS'})',
      tag: LogTags.api,
      subTag: _subTag,
      error: err,
      stackTrace: err.stackTrace,
      json: err.response?.data,
    );

    handler.next(err);
  }
}