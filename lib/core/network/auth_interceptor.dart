// import 'package:dio/dio.dart';
// import 'package:yodoctor/core/constants/log_tags.dart';
// import 'package:yodoctor/core/debug/app_logger.dart';
// import 'package:yodoctor/core/storage/storage_service.dart';
//
// class AuthInterceptor extends Interceptor {
//   AuthInterceptor(this._storage);
//
//   final StorageService _storage;
//   static const String _subTag = 'AuthInterceptor';
//
//   @override
//   void onRequest(
//       RequestOptions options,
//       RequestInterceptorHandler handler,
//       ) {
//     final path = options.path.toLowerCase();
//
//     final isRegistrationApi =
//         path.contains('/doctor/register') ||
//             path.contains('/doctor/registration');
//
//     final token = isRegistrationApi
//         ? _storage.getRegistrationToken()
//         : _storage.getToken();
//
//     AppLogger.info(
//       'Intercepting outgoing HTTP request: [${options.method}] -> ${options.uri}',
//       tag: LogTags.api,
//       subTag: _subTag,
//     );
//
//     if (token != null && token.isNotEmpty) {
//       options.headers['Authorization'] = 'Bearer $token';
//
//       AppLogger.success(
//         'Security context attached safely (${isRegistrationApi ? "Temporary Registration Token" : "Active Session Token"})',
//         tag: LogTags.api,
//         subTag: _subTag,
//       );
//     }
//
//     handler.next(options);
//   }
//
// }


import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/routes/app_router.dart';
import 'package:yodoctor/core/routes/app_routes.dart';
import 'package:yodoctor/core/storage/storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final StorageService _storage;
  static const String _subTag = 'AuthInterceptor';

  static bool _isLoggingOut = false;

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) {
    final path = options.path.toLowerCase();

    final isRegistrationApi =
        path.contains('/doctor/register') ||
            path.contains('/doctor/registration');

    final token = isRegistrationApi
        ? _storage.getRegistrationToken()
        : _storage.getToken();

    AppLogger.info(
      'Intercepting outgoing HTTP request: [${options.method}] -> ${options.uri}',
      tag: LogTags.api,
      subTag: _subTag,
    );

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';

      AppLogger.success(
        'Security context attached safely (${isRegistrationApi ? "Temporary Registration Token" : "Active Session Token"})',
        tag: LogTags.api,
        subTag: _subTag,
      );
    }

    handler.next(options);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    final isTokenExpired = err.response?.statusCode == 401 ||
        err.response?.data?['message'] == 'Token expired';

    if (isTokenExpired) {
      if (!_isLoggingOut) {
        _isLoggingOut = true;

        AppLogger.warning(
          'Session expired or invalid token detected. Triggering force logout...',
          tag: LogTags.api,
          subTag: _subTag,
        );

        await _storage.clearAll();

        final context = AppRouter.rootNavigatorKey.currentContext;
        if (context != null && context.mounted) {
          context.go(AppRoutes.landing);
        }

        Future.delayed(const Duration(seconds: 3), () {
          _isLoggingOut = false;
        });
      }

      return handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          statusCode: 401,
          data: {'success': false, 'message': 'Session Interrupted'},
        ),
      );
    }

    handler.next(err);
  }
}