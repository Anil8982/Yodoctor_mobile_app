import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/config/env_config.dart';
import 'package:yodoctor/core/network/api_interceptor.dart';
import 'package:yodoctor/core/network/auth_interceptor.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.read(storageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(storage),
    ApiInterceptor(),
  ]);

  return dio;
});