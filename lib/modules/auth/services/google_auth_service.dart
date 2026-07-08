import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/models/patient/patient_user.dart';
import 'auth_service.dart';

class GoogleAuthService implements AuthService {
  GoogleAuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance {
    _initializeGoogleSignIn();
  }

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _isGoogleSignInInitialized = false;

  // Single source of truth for the subTag in this file
  static const String _subTag = 'GoogleAuthService';

  /// Initializes the GoogleSignIn plugin instance
  Future<void> _initializeGoogleSignIn() async {
    if (_isGoogleSignInInitialized) return;
    try {
      AppLogger.info(
        'Initializing Google SignIn configuration',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
      AppLogger.success(
        'Google SignIn plugin initialized successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Initialization failed',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    }
  }

  @override
  Future<PatientUser?> signIn() async {
    try {
      AppLogger.info(
        'Starting Google Authentication flow',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      // Ensure instance is ready before launching the native sheet
      if (!_isGoogleSignInInitialized) {
        await _initializeGoogleSignIn();
      }

      // Check for platform support compatibility guard
      if (!_googleSignIn.supportsAuthenticate()) {
        throw Exception(
          'Native authenticating overlay is unsupported on this channel.',
        );
      }

      // 1. Fire the native Google sign-in window selector
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();

      // Guard if user dismisses the dialog manually
      if (googleUser == null) {
        AppLogger.warning(
          'Sign-In flow canceled by the user',
          tag: LogTags.auth,
          subTag: _subTag,
        );
        return null;
      }

      AppLogger.info(
        'Fetching authenticating tokens from account wrapper',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      // 2. Fetch the actual access tokens safely (Crucial await)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Construct the credentials pack for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      AppLogger.info(
        'Exchanging access token parameters with Firebase security layer',
        tag: LogTags.firebase,
        subTag: _subTag,
      );

      // 4. Authorize session with Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'USER_NULL',
          message:
              'Firebase token exchange completed but user payload came back null.',
        );
      }

      AppLogger.highlight(
        'Firebase Identity sync completed for user: ${user.uid}',
      );

      return _mapFirebaseUserToPatient(user);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Google Sign-In process aborted due to an error',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      AppLogger.info(
        'Executing application log-out chain',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      // Clean session reset without deep cache deletion
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      AppLogger.success(
        'User cleared from memory and system routines successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Session termination caught an error',
        tag: LogTags.auth,
        subTag: _subTag,
      );
      rethrow;
    }
  }

  @override
  Future<PatientUser?> getCurrentUser() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _mapFirebaseUserToPatient(user);
  }

  @override
  Future<String?> getIdToken() async {
    return await _firebaseAuth.currentUser?.getIdToken();
  }

  @override
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  @override
  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  /// Private helper mapping routine to keep domain objects isolated
  PatientUser _mapFirebaseUserToPatient(User user) {
    return PatientUser(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      location: '',
      age: 0,
      bloodGroup: '',
      mobileNumber: user.phoneNumber ?? '',
      dateOfBirth: '',
      gender: '',
    );
  }
}
