import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/config/env_config.dart';
import 'package:yodoctor/core/network/api_interceptor.dart';
import 'package:yodoctor/core/network/auth_interceptor.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';

/// Clean Architecture compliant Dio instance provider for YoDoctor.
/// Bypasses the old static instance to allow full testability and mock injection.
final dioProvider = Provider<Dio>((ref) {
  // 🎯 Watch storage to handle reactive dependency coupling correctly
  final storage = ref.watch(storageProvider);

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

  // Register clean pipeline interceptors without duplicate LogInterceptors
  dio.interceptors.addAll([
    AuthInterceptor(storage), // Automatically appends Bearer JWT safely
    ApiInterceptor(),         // Uses AppLogger internally for professional mapping
  ]);

  return dio;
});