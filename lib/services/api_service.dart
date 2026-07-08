import 'package:dio/dio.dart';

class ApiService {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: "http://10.0.2.2:4000",
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            validateStatus: (status) => true,
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestBody: true,
            responseBody: true,
            error: true,
          ),
        );
}
