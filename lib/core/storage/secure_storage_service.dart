import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage_keys.dart';

class SecureStorageService {
  SecureStorageService();

  static const FlutterSecureStorage _storage =
  FlutterSecureStorage();

  Future<void> saveAuthToken(String token) async {
    await _storage.write(
      key: SecureStorageKeys.authToken,
      value: token,
    );
  }

  Future<String?> getAuthToken() {
    return _storage.read(
      key: SecureStorageKeys.authToken,
    );
  }

  Future<void> clearAuthToken() async {
    await _storage.delete(
      key: SecureStorageKeys.authToken,
    );
  }

  Future<void> saveDoctorRegisterToken(String token) async {
    await _storage.write(
      key: SecureStorageKeys.doctorRegisterToken,
      value: token,
    );
  }

  Future<String?> getDoctorRegisterToken() {
    return _storage.read(
      key: SecureStorageKeys.doctorRegisterToken,
    );
  }

  Future<void> clearDoctorRegisterToken() async {
    await _storage.delete(
      key: SecureStorageKeys.doctorRegisterToken,
    );
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}