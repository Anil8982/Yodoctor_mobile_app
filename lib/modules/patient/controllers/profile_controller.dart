import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/dummy_data.dart';

// 🎯 Unified immutable state structure holding current profile payload and async status flags
class ProfileState {
  final bool isLoading;
  final String? errorMessage;
  final PatientUser? user;

  ProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    PatientUser? user,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}

// 🎯 Manual Riverpod Notifier implementation managing dynamic form updates smoothly
class ProfileNotifier extends Notifier<ProfileState> {

  // Permanent text editing controllers mapped out inside the class boundary
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  ProfileState build() {
    // Register automated structural listener cleanups via ref lifecycle hooks
    ref.onDispose(() {
      nameController.dispose();
      emailController.dispose();
      mobileController.dispose();
      dobController.dispose();
      genderController.dispose();
    });

    // 🎯 FIX Step 1: Initialize fields BEFORE adding listeners to block early trigger loops
    final mockUser = DummyData.currentUser;
    _prefillFormFields(mockUser);

    // 🎯 FIX Step 2: Safe initialization wire-up once form text caches are fully mounted
    nameController.addListener(_onFieldChanged);
    emailController.addListener(_onFieldChanged);
    mobileController.addListener(_onFieldChanged);
    dobController.addListener(_onFieldChanged);

    return ProfileState(user: mockUser);
  }

  // Pure logical computed property checking dirty states against stored core entity values
  bool get hasChanges {
    final cachedUser = state.user;
    if (cachedUser == null) return false;
    return nameController.text != cachedUser.name ||
        emailController.text != cachedUser.email ||
        mobileController.text != cachedUser.mobileNumber ||
        dobController.text != cachedUser.dateOfBirth;
  }

  void _onFieldChanged() {
    // 🎯 FIX Step 3: Guard state updates until the notifier initialization handshake finishes completely
    if (state.user == null) return;

    // Re-assign identical states cleanly to force active consumer watchers trigger recalculations
    state = state.copyWith();
  }

  void _prefillFormFields(PatientUser? targetUser) {
    nameController.text = targetUser?.name ?? '';
    emailController.text = targetUser?.email ?? '';
    mobileController.text = targetUser?.mobileNumber ?? '';
    dobController.text = targetUser?.dateOfBirth ?? '';
    genderController.text = targetUser?.gender ?? '';
  }

  void loadProfile() {
    final activeUser = DummyData.currentUser;
    _prefillFormFields(activeUser);
    state = state.copyWith(user: activeUser, errorMessage: null);
  }

  // Trigger transactional remote update queries over repository channels
  Future<void> updateProfile() async {
    state = state.copyWith(isLoading: true);

    // Simulate standard asynchronous processing timeouts delay loop
    await Future.delayed(const Duration(seconds: 1));

    // Update active cache references layout cleanly on operational finish boundary
    if (state.user != null) {
      final freshUserData = PatientUser(
        id: state.user!.id,
        age: state.user!.age,
        location: state.user!.location,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        dateOfBirth: dobController.text.trim(),
        gender: genderController.text,
        bloodGroup: state.user!.bloodGroup, // Retain underlying profile properties
      );
      state = state.copyWith(isLoading: false, user: freshUserData);
      return;
    }

    state = state.copyWith(isLoading: false);
  }

  void discardChanges() {
    loadProfile();
  }
}

// 🎯 Provider declaration mapped with an autoDispose tag setup
final profileProvider = NotifierProvider.autoDispose<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);