import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:yodoctor/core/constants/api_constants.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/network/dio_provider.dart';
import 'package:yodoctor/core/profile_image/profile_image_response.dart';

final profileImageRepoProvider = Provider<ProfileImageRepository>((ref) {
  return ProfileImageRepository(ref.read(dioProvider));
});

class ProfileImageRepository {
  final Dio _dio;
  ProfileImageRepository(this._dio);

  Future<ProfileImageResponse> _handleRequest(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();
      return ProfileImageResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e, st) {
      AppLogger.error('Profile API Error', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<ProfileImageResponse> upload(String path) {
    return _handleRequest(() {
      return _dio.post(
        ApiConstants.uploadProfileImage,
        data: _getFormData(path),
      );
    });
  }

  Future<ProfileImageResponse> update(String path) {
    return _handleRequest(() {
      return _dio.put(
        ApiConstants.updateProfileImage,
        data: _getFormData(path),
      );
    });
  }

  Future<ProfileImageResponse> get() {
    return _handleRequest(() {
      return _dio.get(ApiConstants.getProfileImage);
    });
  }

  Future<ProfileImageResponse> delete() {
    return _handleRequest(() {
      return _dio.delete(ApiConstants.deleteProfileImage);
    });
  }

  FormData _getFormData(String path) {
    final mimeType = lookupMimeType(path) ?? 'image/jpeg';
    final typeParts = mimeType.split('/');
    return FormData.fromMap({
      "image": MultipartFile.fromFileSync(
        path,
        filename: path.split('/').last,
        contentType: MediaType(typeParts[0], typeParts[1]),
      ),
    });
  }
}
