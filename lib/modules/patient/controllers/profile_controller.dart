import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import '../repositories/patient_profile_repository.dart';
import '../screens/profile/models/profile_model.dart';
import '../screens/profile/models/patient_model.dart';

class ProfileState {
  final bool isLoading;
  final String? errorMessage;
  final PatientModel? user;
  final bool hasChanges;

  ProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.hasChanges = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    PatientModel? user,
    bool? hasChanges,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      user: user ?? this.user,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);

class ProfileController extends Notifier<ProfileState> {
  static const String _subTag = 'ProfileController';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  bool _listenersInitialized = false;

  @override
  ProfileState build() {
    ref.onDispose(() {
      nameController.dispose();
      emailController.dispose();
      mobileController.dispose();
      dobController.dispose();
      genderController.dispose();
    });

    _initListeners();
    Future.microtask(loadProfile);
    return ProfileState();
  }

  void _initListeners() {
    if (_listenersInitialized) return;
    _listenersInitialized = true;

    void listener() => _checkChanges();
    nameController.addListener(listener);
    emailController.addListener(listener);
    mobileController.addListener(listener);
    dobController.addListener(listener);
    genderController.addListener(listener);
  }

  void _checkChanges() {
    if (state.user == null) return;
    final changesDetected =
        nameController.text != state.user!.fullName ||
        mobileController.text != state.user!.phone ||
        dobController.text != state.user!.dob ||
        genderController.text != state.user!.gender;

    state = state.copyWith(hasChanges: changesDetected);
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);
    AppLogger.info(
      'Loading patient profile metrics...',
      tag: LogTags.patient,
      subTag: _subTag,
    );

    try {
      final repository = ref.read(patientProfileRepositoryProvider);
      final response = await repository.getProfile();

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final profile = ProfileModel.fromJson(response.data);
        final patient = profile.data;

        nameController.text = patient.fullName;
        emailController.text = patient.email;
        mobileController.text = patient.phone;
        dobController.text = patient.dob;
        genderController.text = patient.gender;

        AppLogger.success(
          'Patient profile metrics loaded successfully',
          tag: LogTags.patient,
          subTag: _subTag,
        );
        AppLogger.json(
          response.data,
          tag: LogTags.patient,
          subTag: '$_subTag/ProfileData',
        );

        state = state.copyWith(
          user: patient,
          isLoading: false,
          hasChanges: false,
        );
      } else {
        final msg = response.data["message"] ?? "Failed to load profile";
        state = state.copyWith(errorMessage: msg, isLoading: false);
        AppLogger.warning(
          'Failed to load profile: $msg',
          tag: LogTags.patient,
          subTag: _subTag,
        );
      }
    } catch (e, st) {
      state = state.copyWith(
        errorMessage: "Failed to load profile",
        isLoading: false,
      );
      AppLogger.exception(
        e,
        st,
        message: 'Profile load halted',
        tag: LogTags.patient,
        subTag: _subTag,
      );
    }
  }

  Future<bool> updateProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final payload = {
      "fullName": nameController.text.trim(),
      "phone": mobileController.text.trim(),
      "gender": genderController.text.trim(),
      "dob": dobController.text.trim(),
    };

    AppLogger.info(
      'Updating patient profile...',
      tag: LogTags.patient,
      subTag: _subTag,
    );
    AppLogger.json(
      payload,
      tag: LogTags.patient,
      subTag: '$_subTag/UpdatePayload',
    );

    try {
      final repository = ref.read(patientProfileRepositoryProvider);
      final response = await repository.updateProfile(
        fullName: nameController.text.trim(),
        phone: mobileController.text.trim(),
        gender: genderController.text.trim(),
        dob: dobController.text.trim(),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        AppLogger.success(
          'Patient profile updated successfully',
          tag: LogTags.patient,
          subTag: _subTag,
        );
        await loadProfile();
        return true;
      } else {
        final msg = response.data["message"] ?? "Failed to update profile";
        state = state.copyWith(errorMessage: msg, isLoading: false);
        AppLogger.warning(
          'Profile update rejected by backend: $msg',
          tag: LogTags.patient,
          subTag: _subTag,
        );
        return false;
      }
    } catch (e, st) {
      state = state.copyWith(
        errorMessage: "Failed to update profile",
        isLoading: false,
      );
      AppLogger.exception(
        e,
        st,
        message: 'Profile write execution faulted',
        tag: LogTags.patient,
        subTag: _subTag,
      );
      return false;
    }
  }

  void discardChanges() {
    AppLogger.info(
      'Discarding profile changes, reloading original data',
      tag: LogTags.patient,
      subTag: _subTag,
    );
    loadProfile();
  }
}
