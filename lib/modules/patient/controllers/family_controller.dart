import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:debug_bubble/debug_bubble.dart';
import '../repositories/patient_family_repository.dart';
import '../models/family/family_member_model.dart';

class FamilyState {
  final List<FamilyMemberModel> members;
  final bool isLoading;
  final String? errorMessage;

  FamilyState({
    this.members = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FamilyState copyWith({
    List<FamilyMemberModel>? members,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FamilyState(
      members: members ?? this.members,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final familyControllerProvider =
NotifierProvider<FamilyController, FamilyState>(FamilyController.new);

class FamilyController extends Notifier<FamilyState> {
  static const String _subTag = 'FamilyController';

  @override
  FamilyState build() {
    Future.microtask(() => loadFamilyMembers());
    return FamilyState();
  }

  String formatDate(DateTime date) {
    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final String day = date.day.toString().padLeft(2, '0');
    return '$day ${months[date.month - 1]} ${date.year}';
  }

  String buildInitials(String name) {
    final List<String> parts = name
        .split(RegExp(r'\s+'))
        .where((String segment) => segment.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'NA';

    if (parts.length == 1) {
      final String firstWord = parts.first;
      if (firstWord.length == 1) return firstWord.toUpperCase();
      return firstWord.substring(0, 2).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String formatNumber(double value) {
    final bool isWhole = value == value.roundToDouble();
    return isWhole ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  }

  Future<void> loadFamilyMembers() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);

    DebugLog.info('Fetching family members...', tag: LogTags.patient, subTag: _subTag);

    try {
      final repository = ref.read(patientFamilyRepositoryProvider);
      final response = await repository.getFamilyMembers();

      if (response.statusCode == 200) {
        final List list = response.data["members"] ?? [];
        final parsedMembers = list.map((e) => FamilyMemberModel.fromJson(e)).toList();

        state = state.copyWith(members: parsedMembers, isLoading: false);
        DebugLog.success('Family members synchronized successfully', tag: LogTags.patient, subTag: _subTag);
      } else {
        final msg = response.data["message"] ?? "Failed to load family sync matrix";
        state = state.copyWith(errorMessage: msg, isLoading: false);
        DebugLog.warning('Failed to load family members: $msg', tag: LogTags.patient, subTag: _subTag);
      }
    } catch (e, st) {
      state = state.copyWith(errorMessage: "Failed to load family members", isLoading: false);
      DebugLog.error('Failed to load family members', error: e, stackTrace: st, tag: LogTags.patient, subTag: _subTag);
    }
  }

  Future<bool> addMember({
    required String fullName,
    required String gender,
    required String dob,
    String? bloodGroup,
    String? heightCm,
    String? weightKg,
    required String relation,
  }) async {
    final payload = {
      "fullName": fullName,
      "gender": gender,
      "dob": dob,
      "bloodGroup": bloodGroup ?? "",
      "heightCm": heightCm ?? "",
      "weightKg": weightKg ?? "",
      "relation": relation,
    };

    DebugLog.info('Adding new family member', tag: LogTags.patient, subTag: _subTag, json: payload);

    try {
      final repository = ref.read(patientFamilyRepositoryProvider);
      final response = await repository.addFamilyMember(payload);

      if (response.statusCode == 201) {
        DebugLog.success('Family member added successfully', tag: LogTags.patient, subTag: _subTag);
        await loadFamilyMembers();
        return true;
      }
      DebugLog.warning('Failed to add family member: ${response.statusCode}', tag: LogTags.patient, subTag: _subTag);
      return false;
    } catch (e, st) {
      DebugLog.error('Add member execution halted', error: e, stackTrace: st, tag: LogTags.patient, subTag: _subTag);
      return false;
    }
  }

  Future<bool> updateMember({
    required int id,
    required String fullName,
    required String gender,
    required String dob,
    String? bloodGroup,
    String? heightCm,
    String? weightKg,
    required String relation,
  }) async {
    final payload = {
      "fullName": fullName,
      "gender": gender,
      "dob": dob,
      "bloodGroup": bloodGroup ?? "",
      "heightCm": heightCm ?? "",
      "weightKg": weightKg ?? "",
      "relation": relation,
    };

    DebugLog.info('Updating family member ID: $id', tag: LogTags.patient, subTag: _subTag, json: payload);

    try {
      final repository = ref.read(patientFamilyRepositoryProvider);
      final response = await repository.updateFamilyMember(id, payload);

      if (response.statusCode == 200) {
        DebugLog.success('Family member ID: $id updated successfully', tag: LogTags.patient, subTag: _subTag);
        await loadFamilyMembers();
        return true;
      }
      DebugLog.warning('Failed to update family member: ${response.statusCode}', tag: LogTags.patient, subTag: _subTag);
      return false;
    } catch (e, st) {
      DebugLog.error('Update member execution halted', error: e, stackTrace: st, tag: LogTags.patient, subTag: _subTag);
      return false;
    }
  }

  Future<bool> deleteMember(int id) async {
    DebugLog.info('Deleting family member ID: $id', tag: LogTags.patient, subTag: _subTag);

    try {
      final repository = ref.read(patientFamilyRepositoryProvider);
      final response = await repository.deleteFamilyMember(id);

      if (response.statusCode == 200) {
        DebugLog.success('Family member ID: $id deleted successfully', tag: LogTags.patient, subTag: _subTag);
        await loadFamilyMembers();
        return true;
      }
      DebugLog.warning('Failed to delete family member: ${response.statusCode}', tag: LogTags.patient, subTag: _subTag);
      return false;
    } catch (e, st) {
      DebugLog.error('Delete member execution halted', error: e, stackTrace: st, tag: LogTags.patient, subTag: _subTag);
      return false;
    }
  }
}