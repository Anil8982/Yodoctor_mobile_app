import 'package:hive/hive.dart';
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

  // 🎯 FIXED: Named methods matching DoctorAuthRepository interop proxies perfectly
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
}