import '../config/env_config.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => EnvConfig.baseUrl;

  static const login = '/auth/login';
  static const forgotPassword = '/auth/forgot-password';
  static const verifyReset = '/auth/verify-reset';
  static const resetPassword = '/auth/reset-password';
  static const patientRegister = '/patient/register';
}