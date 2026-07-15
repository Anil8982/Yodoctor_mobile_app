import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/network/dio_provider.dart';
import 'package:yodoctor/core/providers/storage_provider.dart';
import 'package:yodoctor/core/storage/storage_service.dart';
import '../models/doctor_register_model.dart';
import 'package:path/path.dart' as p;

final doctorAuthRepositoryProvider = Provider<DoctorAuthRepository>((ref) {
  return DoctorAuthRepository(
    dio: ref.read(dioProvider),
    storage: ref.read(storageProvider),
  );
});

class DoctorAuthRepository {
  DoctorAuthRepository({required Dio dio, required StorageService storage})
      : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final StorageService _storage;
  static const String _subTag = 'DoctorAuthRepository';

  Future<Response> login({required String identifier, required String password}) async {
    final payload = {"identifier": identifier, "password": password, "portal": "DOCTOR"};
    AppLogger.info('Initiating doctor login request', tag: LogTags.auth, subTag: _subTag);

    try {
      final response = await _dio.post(ApiConstants.login, data: payload);
      AppLogger.success('Doctor login request completed. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      AppLogger.error('Doctor login transmission failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> registerStep1({
    required String fullName,
    required String email,
    required String mobile,
    required String gender,
    required List<String> languages,
    required String bio,
    required String password,
    required String confirmPassword,
  }) async {
    final payload = {
      "fullName": fullName,
      "email": email,
      "mobile": mobile,
      "gender": gender,
      "languages": languages,
      "bio": bio,
      "password": password,
      "confirmPassword": confirmPassword,
    };

    AppLogger.info("REG TOKEN => ${_storage.getRegistrationToken()}");
    AppLogger.info('Submitting registration step 1 payload', tag: LogTags.auth, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.auth, subTag: '$_subTag/Step1Payload');

    try {
      final response = await _dio.post(ApiConstants.doctorRegisterStep1, data: payload);
      AppLogger.success('Registration step 1 finished. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      AppLogger.error('Registration step 1 network failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> updateRegisterStep1({
    required String fullName,
    required String gender,
    required String bio,
  }) async {
    final payload = {
      "fullName": fullName,
      "gender": gender,
      "bio": bio,
    };
    AppLogger.info("REG TOKEN => ${_storage.getRegistrationToken()}");
    return await _dio.patch(ApiConstants.doctorRegisterUpdateStep1, data: payload);
  }

  Future<Response> registerStep2({
    required String qualification,
    required String specialization,
    required String experience,
    required String regNumber,
    required String stateCouncil,
    required String? validTill,
  }) async {
    final payload = {
      "qualification": qualification,
      "specialization": specialization,
      "experience": experience,
      "regNumber": regNumber,
      "stateCouncil": stateCouncil,
      "validTill": validTill,
    };

    AppLogger.info("REG TOKEN => ${_storage.getRegistrationToken()}");
    AppLogger.info('Submitting registration step 2 payload', tag: LogTags.auth, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.auth, subTag: '$_subTag/Step2Payload');

    try {
      final response = await _dio.patch(ApiConstants.doctorRegisterStep2, data: payload);
      AppLogger.success('Registration step 2 finished. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      AppLogger.error('Registration step 2 network failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> registerStep3({required DoctorFormData data}) async {
    final payload = {
      "clinic": [
        {
          "clinicName": data.clinicName,
          "address": data.address,
          "city": data.city,
          "state": data.state,
          "pincode": data.pincode,
          "landmark": data.landmark,
          "mapsLink": data.mapsLink,
          "languages": data.languages,
        },
      ],
    };

    AppLogger.info('Submitting registration step 3 payload', tag: LogTags.auth, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.auth, subTag: '$_subTag/Step3Payload');

    try {
      final response = await _dio.patch(ApiConstants.doctorRegisterStep3, data: payload);
      AppLogger.success('Registration step 3 finished. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      AppLogger.error('Registration step 3 network failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> registerStep4({required DoctorFormData data}) async {
    AppLogger.info("REG TOKEN => ${_storage.getRegistrationToken()}");
    final payload = {"practiceType": data.practiceType, "hospitalName": data.hospitalName};

    AppLogger.info('Submitting registration step 4 payload', tag: LogTags.auth, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.auth, subTag: '$_subTag/Step4Payload');

    try {
      final response = await _dio.patch(ApiConstants.doctorRegisterStep4, data: payload);
      AppLogger.success('Registration step 4 finished. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      AppLogger.error('Registration step 4 network failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> registerStep5({required DoctorFormData data}) async {
    AppLogger.info("REG TOKEN => ${_storage.getRegistrationToken()}");
    final payload = {
      "fee": data.fee,
      "duration": data.duration,
      "selectedDays": data.selectedDays,
      "morningEnabled": data.morningEnabled,
      "morningStart": data.morningStart.split(":").first,
      "morningEnd": data.morningEnd.split(":").first,
      "eveningEnabled": data.eveningEnabled,
      "eveningStart": data.eveningStart.isEmpty ? null : data.eveningStart.split(":").first,
      "eveningEnd": data.eveningEnd.isEmpty ? null : data.eveningEnd.split(":").first,
    };

    AppLogger.info('Submitting registration step 5 payload', tag: LogTags.auth, subTag: _subTag);
    AppLogger.json(payload, tag: LogTags.auth, subTag: '$_subTag/Step5Payload');

    try {
      final response = await _dio.patch(ApiConstants.doctorRegisterStep5, data: payload);
      AppLogger.success('Registration step 5 finished. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      AppLogger.error('Registration step 5 network failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> registerStep6({required DoctorFormData data}) async {
    AppLogger.info('Compiling and uploading registration multipart fields for step 6', tag: LogTags.auth, subTag: _subTag);
    final token = _storage.getRegistrationToken() ?? _storage.getToken();

    try {
      final formData = FormData.fromMap({
        "profile": await MultipartFile.fromFile(data.profileFile!.path, filename: p.basename(data.profileFile!.path)),
        "certificate": await MultipartFile.fromFile(data.certificateFile!.path, filename: p.basename(data.certificateFile!.path)),
        "idProof": await MultipartFile.fromFile(data.idProofFile!.path, filename: p.basename(data.idProofFile!.path)),
        if (data.clinicProofFile != null)
          "clinicProof": await MultipartFile.fromFile(data.clinicProofFile!.path, filename: p.basename(data.clinicProofFile!.path)),
      });

      final response = await _dio.patch(
        ApiConstants.doctorRegisterStep6,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            if (token != null) "Authorization": "Bearer $token",
          },
        ),
      );
      return response;
    } catch (e, st) {
      AppLogger.error('Registration step 6 upload failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> submitRegistration({required DoctorFormData data}) async {
    final payload = {
      "accurate": data.declAccurate,
      "display": data.declDisplay,
      "privacy": data.declPrivacy,
      "terms": data.declTerms,
    };

    try {
      return await _dio.patch(ApiConstants.doctorRegisterSubmit, data: payload);
    } catch (e, st) {
      AppLogger.error('Final registration submission execution loss', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  // --------------------------------------------------------
  // 🎯 Persistent Session & Role Management Proxies (FIXED)
  // --------------------------------------------------------

  Future<String?> getSessionToken() async {
    return _storage.getToken();
  }

  Future<void> saveSessionToken(String token) async {
    AppLogger.info('Storing fresh user context session token', tag: LogTags.auth, subTag: _subTag);
    await _storage.saveToken(token);
  }

  Future<void> saveRegistrationToken(String token) async {
    AppLogger.info('Storing temporary setup registration token key', tag: LogTags.auth, subTag: _subTag);
    await _storage.saveRegistrationToken(token);
  }

  Future<void> saveUserRole(String role) async {
    AppLogger.info('Caching user role descriptor natively: $role', tag: LogTags.auth, subTag: _subTag);
    await _storage.saveRole(role);
  }

  Future<String?> getUserRole() async {
    return _storage.getRole();
  }

  Future<void> clearAuthSession() async {
    AppLogger.info('Flushing auth session local records and clearing identifiers', tag: LogTags.auth, subTag: _subTag);
    await _storage.clearToken();
    await _storage.clearRegistrationToken();
    await _storage.clearRole();
    await _storage.clearAll();
  }
}
