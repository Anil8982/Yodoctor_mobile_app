import 'dart:io';
import 'package:dio/dio.dart';

class AppErrorUtils {
  AppErrorUtils._();

  /// Converts any exception or error message into a clean, human-friendly message.
  /// Never exposes raw technical exceptions like DioException, SocketException,
  /// 401 Unauthorized, FormatException, or null check errors to the user.
  static String getFriendlyMessage(
    dynamic error, {
    String? defaultMessage,
    String? fallbackMessage,
  }) {
    final defaultFallback = defaultMessage ?? fallbackMessage ?? 'Something went wrong. Please try again.';

    if (error == null) return defaultFallback;

    // Handle DioException specifically
    if (error is DioException) {
      return _parseDioException(error, defaultFallback);
    }

    if (error is SocketException) {
      return 'Unable to connect right now. Please check your internet connection and try again.';
    }

    if (error is FormatException) {
      return 'Invalid data received. Please try again.';
    }

    final rawString = error.toString();
    return sanitizeErrorMessage(rawString, defaultFallback);
  }

  static String _parseDioException(DioException dioError, String defaultFallback) {
    // Check for network connection / timeout errors
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet connection and try again.';
      case DioExceptionType.connectionError:
        return 'Unable to connect right now. Please check your internet connection and try again.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        final responseData = dioError.response?.data;

        // Try extracting backend message first
        String? backendMsg;
        if (responseData is Map<String, dynamic>) {
          backendMsg = responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              responseData['msg']?.toString();
        } else if (responseData is String && !responseData.trim().startsWith('<')) {
          backendMsg = responseData.trim();
        }

        if (backendMsg != null && backendMsg.trim().isNotEmpty) {
          final sanitized = sanitizeErrorMessage(backendMsg, '');
          if (sanitized.isNotEmpty) {
            return sanitized;
          }
        }

        // Status code specific defaults
        if (statusCode == 400) {
          return 'Invalid request. Please check the entered information.';
        } else if (statusCode == 401) {
          return 'Incorrect OTP or credentials. Please check and try again.';
        } else if (statusCode == 403) {
          return 'Access denied. You do not have permission for this action.';
        } else if (statusCode == 404) {
          return 'Requested resource not found. Please try again.';
        } else if (statusCode == 409) {
          return 'Account or record already exists.';
        } else if (statusCode == 422) {
          return 'Please provide all required valid details.';
        } else if (statusCode == 429) {
          return 'Too many OTP requests. Please wait a moment before trying again.';
        } else if (statusCode != null && statusCode >= 500) {
          return 'Something went wrong on our side. Please try again in a moment.';
        }
        return defaultFallback;

      case DioExceptionType.badCertificate:
        return 'Security certificate verification failed. Please check your network.';
      case DioExceptionType.unknown:
      default:
        if (dioError.error is SocketException) {
          return 'Unable to connect right now. Please check your internet connection and try again.';
        }
        final message = dioError.message;
        if (message != null && message.isNotEmpty) {
          return sanitizeErrorMessage(message, defaultFallback);
        }
        return defaultFallback;
    }
  }

  /// Sanitizes any raw error string to ensure no technical leakages
  static String sanitizeErrorMessage(String raw, [String fallback = 'Something went wrong. Please try again.']) {
    String clean = raw.replaceAll('Exception:', '').trim();

    final lower = clean.toLowerCase();

    // Check for technical/system crash keywords
    final hasTechnicalArtifacts = lower.contains('dioexception') ||
        lower.contains('socketexception') ||
        lower.contains('formatexception') ||
        lower.contains('unauthorized') ||
        lower.contains('internal server error') ||
        lower.contains('null check operator') ||
        lower.contains('connection refused') ||
        lower.contains('subtype of') ||
        lower.contains('syntaxerror') ||
        lower.contains('stacktrace') ||
        lower.contains('nosuchmethoderror') ||
        lower.contains('typeerror') ||
        lower.contains('errno =') ||
        lower.contains('os error:') ||
        lower.contains('xmlhttprequest') ||
        lower.contains('failed host lookup') ||
        lower.contains('status code of 40') ||
        lower.contains('status code of 50') ||
        lower.contains('handshakeexception');

    // Specific OTP error conditions
    if (lower.contains('invalid otp') ||
        lower.contains('incorrect otp') ||
        lower.contains('wrong otp') ||
        lower.contains('otp does not match') ||
        lower.contains('otp is invalid') ||
        lower.contains('otp verification failed')) {
      return 'Incorrect OTP. Please check the code and try again.';
    }

    if (lower.contains('expired otp') ||
        lower.contains('otp expired') ||
        lower.contains('otp has expired')) {
      return 'This OTP has expired. Please request a new OTP.';
    }

    if (lower.contains('invalid verification id') ||
        lower.contains('verification id not found') ||
        lower.contains('invalid verificationid')) {
      return 'Verification session expired. Please request a new OTP.';
    }

    // Rate limiting
    if (lower.contains('too many request') ||
        lower.contains('rate limit') ||
        lower.contains('too many otp') ||
        lower.contains('wait before')) {
      return 'Too many OTP requests. Please wait a moment before trying again.';
    }

    // Already registered checks
    if ((lower.contains('email') && (lower.contains('already exists') || lower.contains('already registered') || lower.contains('taken') || lower.contains('duplicate')))) {
      return 'This email is already registered. Please use a different email or log in.';
    }

    if ((lower.contains('mobile') || lower.contains('phone')) &&
        (lower.contains('already exists') || lower.contains('already registered') || lower.contains('taken') || lower.contains('duplicate'))) {
      return 'This mobile number is already registered. Please use a different number or log in.';
    }

    // Network issues
    if (lower.contains('network') ||
        lower.contains('connection refused') ||
        lower.contains('failed host lookup') ||
        lower.contains('timed out') ||
        lower.contains('no internet') ||
        lower.contains('socketexception')) {
      return 'Unable to connect right now. Please check your internet connection and try again.';
    }

    // Server issues
    if (lower.contains('server error') ||
        lower.contains('internal server') ||
        lower.contains('bad gateway') ||
        lower.contains('service unavailable') ||
        lower.contains('500') ||
        lower.contains('502') ||
        lower.contains('503')) {
      return 'Something went wrong on our side. Please try again in a moment.';
    }

    if (hasTechnicalArtifacts) {
      return fallback;
    }

    // Safe backend message
    if (clean.isNotEmpty && clean.length <= 150) {
      return clean;
    }

    return fallback;
  }
}
