import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'profile_image_repository.dart';

final profileImageController = AsyncNotifierProvider<ProfileImageController, String?>(ProfileImageController.new);

class ProfileImageController extends AsyncNotifier<String?> {
  static const String _tag = LogTags.profile;
  static const String _subTag = 'ProfileImage';

  @override
  Future<String?> build() async {
    try {
      final res = await ref.read(profileImageRepoProvider).get();
      return res.success ? res.imageUrl : null;
    } catch (e, st) {
      AppLogger.error('Failed to load profile image', tag: _tag, subTag: _subTag, error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> upload(String path) => _processUpload(path, isUpdate: false);
  Future<void> updateImage(String path) => _processUpload(path, isUpdate: true);

  Future<void> _processUpload(String path, {required bool isUpdate}) async {
    final file = File(path);
    if (!file.existsSync()) {
      state = AsyncError('File not found', StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    try {
      final res = isUpdate
          ? await ref.read(profileImageRepoProvider).update(path)
          : await ref.read(profileImageRepoProvider).upload(path);

      if (res.success) {
        state = AsyncData(res.imageUrl);
      } else {
        throw Exception('Server returned failure');
      }
    } catch (e, st) {
      AppLogger.error('Upload operation failed', tag: _tag, subTag: _subTag, error: e, stackTrace: st);
      state = AsyncError(e, st);
    }
  }

  Future<void> delete() async {
    state = const AsyncLoading();
    try {
      final res = await ref.read(profileImageRepoProvider).delete();
      if (res.success) {
        state = const AsyncData(null);
      } else {
        throw Exception('Delete API failed');
      }
    } catch (e, st) {
      AppLogger.error('Delete operation failed', tag: _tag, subTag: _subTag, error: e, stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}