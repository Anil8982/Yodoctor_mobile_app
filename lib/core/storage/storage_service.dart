// import 'package:hive/hive.dart';
// import 'package:yodoctor/core/enums/auth_type.dart';
// import 'hive_boxes.dart';
// import 'hive_keys.dart';
//
// class StorageService {
//   StorageService();
//
//   Box get _box => Hive.box(HiveBoxes.appStorage);
//
//   // ----------------------------
//   // Auth Token
//   // ----------------------------
//
//   Future<void> saveToken(String token) async {
//     await _box.put(HiveKeys.authToken, token);
//   }
//
//   String? getToken() {
//     return _box.get(HiveKeys.authToken);
//   }
//
//   Future<void> clearToken() async {
//     await _box.delete(HiveKeys.authToken);
//   }
//
//   // ----------------------------
//   // Doctor Registration Token
//   // ----------------------------
//
//   Future<void> saveRegistrationToken(String token) async {
//     await _box.put(HiveKeys.doctorRegisterToken, token);
//   }
//
//   String? getRegistrationToken() {
//     return _box.get(HiveKeys.doctorRegisterToken);
//   }
//
//   Future<void> clearRegistrationToken() async {
//     await _box.delete(HiveKeys.doctorRegisterToken);
//   }
//
//   // ----------------------------
//   // 🎯 User Role Management (ADDED FOR PERSISTENT LOGIN)
//   // ----------------------------
//
//   Future<void> saveRole(String role) async {
//     await _box.put(HiveKeys.appRole, role);
//   }
//
//   String? getRole() {
//     return _box.get(HiveKeys.appRole);
//   }
//
//   Future<void> clearRole() async {
//     await _box.delete(HiveKeys.appRole);
//   }
//
//   // ----------------------------
//   // Authentication Type
//   // ----------------------------
//
//   Future<void> saveAuthType(AuthType authType) async {
//     await _box.put(HiveKeys.authType, authType.name);
//   }
//
//   AuthType? getAuthType() {
//     final value = _box.get(HiveKeys.authType);
//
//     if (value == null) return null;
//
//     return AuthType.values.cast<AuthType?>().firstWhere(
//           (type) => type?.name == value,
//       orElse: () => null,
//     );
//   }
//
//   Future<void> clearAuthType() async {
//     await _box.delete(HiveKeys.authType);
//   }
//
//   // ----------------------------
//   // Generic Helpers
//   // ----------------------------
//
//   Future<void> saveData(String key, dynamic value) async {
//     await _box.put(key, value);
//   }
//
//   T? getData<T>(String key) {
//     return _box.get(key) as T?;
//   }
//
//   Future<void> remove(String key) async {
//     await _box.delete(key);
//   }
//
//   Future<void> clearAll() async {
//     await _box.clear();
//   }
//
//   // ----------------------------
//   // Doctor Status Management
//   // ----------------------------
//
//   Future<void> saveStatus(String status) async {
//     await _box.put(HiveKeys.doctorStatus, status);
//   }
//
//   String? getStatus() {
//     return _box.get(HiveKeys.doctorStatus);
//   }
//
//   Future<void> clearStatus() async {
//     await _box.delete(HiveKeys.doctorStatus);
//   }
//
//
//   // ----------------------------
//   // Doctor Active Subscription Status Management
//   // ----------------------------
//
//   Future<void> saveActiveSubscription(bool hasSubscription) async {
//     await _box.put(HiveKeys.activeSubscription, hasSubscription);
//   }
//
//   bool? getActiveSubscription() {
//     return _box.get(HiveKeys.activeSubscription) as bool?;
//   }
//
//   Future<void> clearActiveSubscription() async {
//     await _box.delete(HiveKeys.activeSubscription);
//   }
// }

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:yodoctor/core/enums/auth_type.dart';
import 'package:yodoctor/modules/app_config/models/app_config_model.dart';

import 'hive_boxes.dart';
import 'hive_keys.dart';
import 'secure_storage_service.dart';

class StorageService {
  StorageService();

  Box get _box => Hive.box(HiveBoxes.appStorage);

  final SecureStorageService _secureStorage = SecureStorageService();
  Box get _appConfigBox => Hive.box(HiveBoxes.appConfig);

  String? _cachedToken;
  String? _cachedRegistrationToken;

  // Initialize
  Future<void> initialize() async {
    _cachedToken = await _secureStorage.getAuthToken();
    _cachedRegistrationToken = await _secureStorage.getDoctorRegisterToken();
  }

  // Auth Token
  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _secureStorage.saveAuthToken(token);
  }
  String? getToken() {
    return _cachedToken;
  }
  Future<void> clearToken() async {
    _cachedToken = null;
    await _secureStorage.clearAuthToken();
  }

  // Doctor Registration Token
  Future<void> saveRegistrationToken(String token) async {
    _cachedRegistrationToken = token;
    await _secureStorage.saveDoctorRegisterToken(token);
  }
  String? getRegistrationToken() {
    return _cachedRegistrationToken;
  }
  Future<void> clearRegistrationToken() async {
    _cachedRegistrationToken = null;
    await _secureStorage.clearDoctorRegisterToken();
  }

  // User Role
  Future<void> saveRole(String role) async {
    await _box.put(HiveKeys.appRole, role);
  }
  String? getRole() {
    return _box.get(HiveKeys.appRole) as String?;
  }
  Future<void> clearRole() async {
    await _box.delete(HiveKeys.appRole);
  }

  // Authentication Type
  Future<void> saveAuthType(AuthType authType) async {
    await _box.put(HiveKeys.authType, authType.name);
  }
  AuthType? getAuthType() {
    final value = _box.get(HiveKeys.authType);
    if (value == null) return null;
    return AuthType.values.cast<AuthType?>().firstWhere(
      (type) => type?.name == value,
      orElse: () => null,
    );
  }
  Future<void> clearAuthType() async {
    await _box.delete(HiveKeys.authType);
  }

  // Generic Helpers
  Future<void> saveData(String key, dynamic value) async {
    await _box.put(key, value);
  }
  T? getData<T>(String key) {
    final value = _box.get(key);
    if (value == null) return null;
    return value as T;
  }

  Future<void> remove(String key) async {
    await _box.delete(key);
  }

  // Doctor Status
  Future<void> saveStatus(String status) async {
    await _box.put(HiveKeys.doctorStatus, status);
  }
  String? getStatus() {
    return _box.get(HiveKeys.doctorStatus) as String?;
  }
  Future<void> clearStatus() async {
    await _box.delete(HiveKeys.doctorStatus);
  }

  // Active Subscription
  Future<void> saveActiveSubscription(bool hasSubscription) async {
    await _box.put(HiveKeys.activeSubscription, hasSubscription);
  }
  bool? getActiveSubscription() {
    return _box.get(HiveKeys.activeSubscription) as bool?;
  }
  Future<void> clearActiveSubscription() async {
    await _box.delete(HiveKeys.activeSubscription);
  }

  // App Config
  Future<void> saveAppConfig(AppConfigModel config) async {
    await _appConfigBox.put(
      HiveKeys.appConfig,
      jsonEncode(config.toJson()),
    );
  }

  AppConfigModel? getAppConfig() {
    final value = _appConfigBox.get(HiveKeys.appConfig);

    if (value == null) return null;

    try {
      final json = jsonDecode(value as String) as Map<String, dynamic>;

      return AppConfigModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAppConfig() async {
    await _appConfigBox.delete(HiveKeys.appConfig);
  }

  // Clear All
  Future<void> clearAll() async {
    _cachedToken = null;
    _cachedRegistrationToken = null;

    await _box.clear();
    await _secureStorage.clearAll();
  }
}
