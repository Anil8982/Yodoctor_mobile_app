import 'package:dio/dio.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/storage/storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final StorageService _storage;
  static const String _subTag = 'AuthInterceptor';

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    final regToken = _storage.getRegistrationToken();
    final mainToken = _storage.getToken();
    final token = regToken ?? mainToken;

    AppLogger.info('Intercepting outgoing HTTP request: [${options.method}] -> ${options.uri}', tag: LogTags.api, subTag: _subTag);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';

      final tokenType = regToken != null ? "Temporary Registration Token" : "Active Session Token";
      AppLogger.success('Security context attached safely ($tokenType)', tag: LogTags.api, subTag: _subTag);
    } else {
      AppLogger.warning('No active authentication token discovered in secure storage nodes', tag: LogTags.api, subTag: _subTag);
    }

    handler.next(options);
  }
}