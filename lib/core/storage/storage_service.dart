import 'package:hive/hive.dart';
import 'package:yodoctor/core/enums/auth_type.dart';
import 'hive_boxes.dart';
import 'hive_keys.dart';

class StorageService {
  StorageService();

  Box get _box => Hive.box(HiveBoxes.appStorage);

  // ----------------------------
  // Auth Token
  // ----------------------------

  Future<void> saveToken(String token) async {
    await _box.put(HiveKeys.authToken, token);
  }

  String? getToken() {
    return _box.get(HiveKeys.authToken);
  }

  Future<void> clearToken() async {
    await _box.delete(HiveKeys.authToken);
  }

  // ----------------------------
  // Doctor Registration Token
  // ----------------------------

  Future<void> saveRegistrationToken(String token) async {
    await _box.put(HiveKeys.doctorRegisterToken, token);
  }

  String? getRegistrationToken() {
    return _box.get(HiveKeys.doctorRegisterToken);
  }

  Future<void> clearRegistrationToken() async {
    await _box.delete(HiveKeys.doctorRegisterToken);
  }

  // ----------------------------
  // 🎯 User Role Management (ADDED FOR PERSISTENT LOGIN)
  // ----------------------------

  Future<void> saveRole(String role) async {
    await _box.put(HiveKeys.appRole, role);
  }

  String? getRole() {
    return _box.get(HiveKeys.appRole);
  }

  Future<void> clearRole() async {
    await _box.delete(HiveKeys.appRole);
  }

  // ----------------------------
  // Authentication Type
  // ----------------------------

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

  // ----------------------------
  // Generic Helpers
  // ----------------------------

  Future<void> saveData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  T? getData<T>(String key) {
    return _box.get(key) as T?;
  }

  Future<void> remove(String key) async {
    await _box.delete(key);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  // ----------------------------
  // Doctor Status Management
  // ----------------------------

  Future<void> saveStatus(String status) async {
    await _box.put(HiveKeys.doctorStatus, status);
  }

  String? getStatus() {
    return _box.get(HiveKeys.doctorStatus);
  }

  Future<void> clearStatus() async {
    await _box.delete(HiveKeys.doctorStatus);
  }
}