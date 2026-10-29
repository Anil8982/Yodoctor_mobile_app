import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
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
    DebugLog.info('Initiating doctor login request', tag: LogTags.auth, subTag: _subTag);

    try {
      final response = await _dio.post(ApiConstants.login, data: payload);
      DebugLog.success('Doctor login request completed. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      DebugLog.error('Doctor login transmission failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> sendLoginOtp({required String identifier}) async {
    final payload = {
      "identifier": identifier.trim(),
      "password": "",
      "portal": "DOCTOR",
      "loginWithOtp": true,
    };
    DebugLog.info('Initiating doctor send login OTP request to /auth/login', tag: LogTags.auth, subTag: _subTag);

    try {
      final response = await _dio.post(ApiConstants.login, data: payload);
      DebugLog.success('Doctor send login OTP completed. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      DebugLog.error('Doctor send login OTP transmission failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> verifyLoginOtp({
    required String otp,
    String? verificationId,
    String? channel,
    String? mobile,
    String? email,
    String? identifier,
  }) async {
    final payload = {
      "otp": otp.trim(),
      if (channel != null && channel.isNotEmpty) "channel": channel.toUpperCase(),
      if (verificationId != null && verificationId.isNotEmpty) "verificationId": verificationId,
      if (mobile != null && mobile.isNotEmpty) "mobile": mobile,
      if (email != null && email.isNotEmpty) "email": email,
      if (identifier != null && identifier.isNotEmpty) "identifier": identifier,
      "portal": "DOCTOR",
    };
    DebugLog.info('Initiating doctor OTP verification request', tag: LogTags.auth, subTag: _subTag);

    try {
      final response = await _dio.post(ApiConstants.verifyLoginOtp, data: payload);
      DebugLog.success('Doctor OTP verification completed. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      DebugLog.error('Doctor OTP verification transmission failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
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

    DebugLog.info("REG TOKEN => ${_storage.getRegistrationToken()}");
    DebugLog.info('Submitting registration step 1 payload', tag: LogTags.auth, subTag: _subTag);
    DebugLog.debug(
      'Step 1 payload',
      tag: LogTags.auth,
      subTag: '$_subTag/Step1Payload',
      json: payload,
    );

    try {
      final response = await _dio.post(ApiConstants.doctorRegisterStep1, data: payload);
      DebugLog.success('Registration step 1 finished. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      DebugLog.error('Registration step 1 network failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
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
    DebugLog.info("REG TOKEN => ${_storage.getRegistrationToken()}");
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

    DebugLog.info("REG TOKEN => ${_storage.getRegistrationToken()}");
    DebugLog.info('Submitting registration step 2 payload', tag: LogTags.auth, subTag: _subTag);
    DebugLog.debug(
      'Step 2 payload',
      tag: LogTags.auth,
      subTag: '$_subTag/Step2Payload',
      json: payload,
    );

    try {
      final response = await _dio.patch(ApiConstants.doctorRegisterStep2, data: payload);
      DebugLog.success('Registration step 2 finished. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      DebugLog.error('Registration step 2 network failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
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

    DebugLog.info('Submitting registration step 3 payload', tag: LogTags.auth, subTag: _subTag);
    DebugLog.debug(
      'Step 3 payload',
      tag: LogTags.auth,
      subTag: '$_subTag/Step3Payload',
      json: payload,
    );

    try {
      final response = await _dio.patch(ApiConstants.doctorRegisterStep3, data: payload);
      DebugLog.success('Registration step 3 finished. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      DebugLog.error('Registration step 3 network failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> registerStep4({required DoctorFormData data}) async {
    DebugLog.info("REG TOKEN => ${_storage.getRegistrationToken()}");
    final payload = {"practiceType": data.practiceType, "hospitalName": data.hospitalName};

    DebugLog.info('Submitting registration step 4 payload', tag: LogTags.auth, subTag: _subTag);
    DebugLog.debug(
      'Step 4 payload',
      tag: LogTags.auth,
      subTag: '$_subTag/Step4Payload',
      json: payload,
    );

    try {
      final response = await _dio.patch(ApiConstants.doctorRegisterStep4, data: payload);
      DebugLog.success('Registration step 4 finished. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      DebugLog.error('Registration step 4 network failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> registerStep5({required DoctorFormData data}) async {
    DebugLog.info("REG TOKEN => ${_storage.getRegistrationToken()}");
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

    DebugLog.info('Submitting registration step 5 payload', tag: LogTags.auth, subTag: _subTag);
    DebugLog.debug(
      'Step 5 payload',
      tag: LogTags.auth,
      subTag: '$_subTag/Step5Payload',
      json: payload,
    );

    try {
      final response = await _dio.patch(ApiConstants.doctorRegisterStep5, data: payload);
      DebugLog.success('Registration step 5 finished. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      DebugLog.error('Registration step 5 network failure', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Response> registerStep6({
    required DoctorFormData data,
  }) async {
    DebugLog.info(
      'Compiling and uploading registration multipart fields for step 6',
      tag: LogTags.auth,
      subTag: _subTag,
    );

    try {
      final formData = FormData.fromMap({
        "profile": await MultipartFile.fromFile(
          data.profileFile!.path,
          filename: p.basename(data.profileFile!.path),
        ),
        "certificate": await MultipartFile.fromFile(
          data.certificateFile!.path,
          filename: p.basename(data.certificateFile!.path),
        ),
        "idProof": await MultipartFile.fromFile(
          data.idProofFile!.path,
          filename: p.basename(data.idProofFile!.path),
        ),
        if (data.clinicProofFile != null)
          "clinicProof": await MultipartFile.fromFile(
            data.clinicProofFile!.path,
            filename: p.basename(data.clinicProofFile!.path),
          ),
      });

      final response = await _dio.patch(
        ApiConstants.doctorRegisterStep6,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );

      DebugLog.info(
        'Step6 files → '
            'profile=${data.profileFile?.path} | '
            'certificate=${data.certificateFile?.path} | '
            'idProof=${data.idProofFile?.path} | '
            'clinicProof=${data.clinicProofFile?.path}',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return response;
    } catch (e, st) {
      DebugLog.error(
        'Registration step 6 upload failure',
        tag: LogTags.auth,
        subTag: _subTag,
        error: e,
        stackTrace: st,
      );
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

    DebugLog.info('Submitting final declaration payload to ${ApiConstants.doctorRegisterSubmit}', tag: LogTags.auth, subTag: _subTag);
    DebugLog.debug(
      'Declaration payload',
      tag: LogTags.auth,
      subTag: '$_subTag/DeclarationPayload',
      json: payload,
    );

    try {
      final response = await _dio.patch(ApiConstants.doctorRegisterSubmit, data: payload);
      DebugLog.success('Final declaration submitted successfully. Status: ${response.statusCode}', tag: LogTags.auth, subTag: _subTag);
      return response;
    } catch (e, st) {
      DebugLog.error('Final registration submission execution loss', tag: LogTags.auth, subTag: _subTag, error: e, stackTrace: st);
      rethrow;
    }
  }

  // --------------------------------------------------------
  // 🎯 Persistent Session & Role Management Proxies (FIXED)
  // --------------------------------------------------------

  Future<String?> getSessionToken() async {
    return _storage.getToken();
  }

  Future<String?> getRegistrationToken() async {
    return _storage.getRegistrationToken();
  }

  Future<void> saveSessionToken(String token) async {
    DebugLog.info('Storing fresh user context session token', tag: LogTags.auth, subTag: _subTag);
    await _storage.saveToken(token);
  }

  Future<void> saveRegistrationToken(String token) async {
    DebugLog.info('Storing temporary setup registration token key', tag: LogTags.auth, subTag: _subTag);
    await _storage.saveRegistrationToken(token);
  }

  Future<void> saveUserRole(String role) async {
    DebugLog.info('Caching user role descriptor natively: $role', tag: LogTags.auth, subTag: _subTag);
    await _storage.saveRole(role);
  }

  Future<String?> getUserRole() async {
    return _storage.getRole();
  }

  Future<void> saveStatus(String status) async {
    await _storage.saveStatus(status);
  }

  String? getStatus() {
    return _storage.getStatus();
  }

  Future<void> clearAuthSession() async {
    DebugLog.info('Flushing auth session local records and clearing identifiers', tag: LogTags.auth, subTag: _subTag);
    await _storage.clearToken();
    await _storage.clearRegistrationToken();
    await _storage.clearRole();
    await _storage.clearStatus();
    await _storage.clearActiveSubscription();
    await _storage.clearAll();
  }
}
