import 'dart:developer' as developer;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:yodoctor/core/constants/log_tags.dart';

enum LogLevel { debug, info, success, warning, error, critical }

class AppLogger {
  // Safe default: standard logging completely guarded by build mode
  static bool enableLogs = kDebugMode;

  static const String _reset = '\x1B[0m';
  static const String _gray = '\x1B[90m';
  static const String _cyan = '\x1B[36m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';
  static const String _magenta = '\x1B[35m';

  static void _log(
    String message, {
    LogLevel level = LogLevel.debug,
    String tag = LogTags.app,
    String? subTag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!enableLogs) return;

    // Strict release mode enforcement for verbose tiers
    if (kReleaseMode && (level == LogLevel.debug || level == LogLevel.info)) {
      return;
    }

    // Optimized: single instantiation for timestamping
    final now = DateTime.now();
    final time = now.toIso8601String().split('T').last;

    String emoji;
    int devLevel;
    String color;

    switch (level) {
      case LogLevel.debug:
        emoji = "🐛";
        devLevel = 500;
        color = _gray;
        break;
      case LogLevel.info:
        emoji = "ℹ️";
        devLevel = 800;
        color = _cyan;
        break;
      case LogLevel.success:
        emoji = "✅";
        devLevel = 850;
        color = _green;
        break;
      case LogLevel.warning:
        emoji = "⚠️";
        devLevel = 900;
        color = _yellow;
        break;
      case LogLevel.error:
        emoji = "❌";
        devLevel = 1000;
        color = _red;
        break;
      case LogLevel.critical:
        emoji = "🔥";
        devLevel = 1200;
        color = _magenta;
        break;
    }

    final subTagStr = (subTag != null && subTag.isNotEmpty) ? "[$subTag]" : "";
    final logMessage =
        "$color$emoji [$tag]$subTagStr [$time] → $message$_reset";

    debugPrint(logMessage);

    developer.log(
      message,
      name: subTag != null ? "$tag/$subTag" : tag,
      time: now,
      level: devLevel,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void debug(String msg, {String tag = LogTags.app, String? subTag}) {
    _log(msg, level: LogLevel.debug, tag: tag, subTag: subTag);
  }

  static void info(String msg, {String tag = LogTags.app, String? subTag}) {
    _log(msg, level: LogLevel.info, tag: tag, subTag: subTag);
  }

  static void success(String msg, {String tag = LogTags.app, String? subTag}) {
    _log(msg, level: LogLevel.success, tag: tag, subTag: subTag);
  }

  static void warning(String msg, {String tag = LogTags.app, String? subTag}) {
    _log(msg, level: LogLevel.warning, tag: tag, subTag: subTag);
  }

  static void error(
    String msg, {
    String tag = LogTags.app,
    String? subTag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      msg,
      level: LogLevel.error,
      tag: tag,
      subTag: subTag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void critical(
    String msg, {
    String tag = LogTags.app,
    String? subTag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      msg,
      level: LogLevel.critical,
      tag: tag,
      subTag: subTag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void exception(
    Object error,
    StackTrace stackTrace, {
    String message = "An unexpected error occurred",
    String tag = LogTags.app,
    String? subTag,
  }) {
    _log(
      message,
      level: LogLevel.error,
      tag: tag,
      subTag: subTag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void section(String title, {String tag = LogTags.app}) {
    if (kReleaseMode || !enableLogs) return;
    debugPrint("\n$_cyan========== 🔷 [$tag] $title 🔷 ==========$_reset\n");
  }

  static void json(
      dynamic data, {
        String tag = LogTags.api,
        String? subTag,
      }) {
    if (kReleaseMode || !enableLogs) return;

    try {
      const encoder = JsonEncoder.withIndent('  ');
      final pretty = encoder.convert(data);

      final subTagStr =
      (subTag != null && subTag.isNotEmpty)
          ? "[$subTag]"
          : "";

      debugPrint(
        "$_green📦 [$tag]$subTagStr JSON Data →\n$pretty$_reset",
      );
    } catch (_) {
      _log(
        "Failed to parse JSON payload",
        level: LogLevel.error,
        tag: tag,
        subTag: subTag,
      );
    }
  }

  static void highlight(String msg) {
    if (kReleaseMode || !enableLogs) return;
    debugPrint("\n$_green✨🚀✨ $msg ✨🚀✨$_reset\n");
  }
}
