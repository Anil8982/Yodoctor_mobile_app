import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yodoctor/core/constants/log_tags.dart';
import 'package:yodoctor/core/debug/app_logger.dart';
import 'package:yodoctor/core/models/patient/patient_user.dart';

class GoogleAuthService {
  GoogleAuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance {
    _initializeGoogleSignIn();
  }

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  bool _isGoogleSignInInitialized = false;

  static const String _subTag = 'GoogleAuthService';

  Future<void> _initializeGoogleSignIn() async {
    if (_isGoogleSignInInitialized) return;

    try {
      AppLogger.info(
        'Initializing Google Sign-In',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      await _googleSignIn.initialize();

      _isGoogleSignInInitialized = true;

      AppLogger.success(
        'Google Sign-In initialized',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Failed to initialize Google Sign-In',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      rethrow;
    }
  }

  Future<PatientUser?> signInWithGoogle() async {
    try {
      AppLogger.info(
        'Starting Google authentication flow',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      if (!_isGoogleSignInInitialized) {
        await _initializeGoogleSignIn();
      }

      if (!_googleSignIn.supportsAuthenticate()) {
        throw Exception(
          'Google authentication is not supported on this platform.',
        );
      }

      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'USER_NULL',
          message: 'Authenticated user is null.',
        );
      }

      AppLogger.success(
        'Google login successful',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      return _mapFirebaseUserToPatient(user);
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Google Sign-In failed',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      AppLogger.success(
        'User signed out successfully',
        tag: LogTags.auth,
        subTag: _subTag,
      );
    } catch (e, st) {
      AppLogger.exception(
        e,
        st,
        message: 'Failed to sign out',
        tag: LogTags.auth,
        subTag: _subTag,
      );

      rethrow;
    }
  }

  Future<PatientUser?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    return _mapFirebaseUserToPatient(user);
  }

  Future<String?> getIdToken() async {
    return _firebaseAuth.currentUser?.getIdToken();
  }

  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  PatientUser _mapFirebaseUserToPatient(User user) {
    return PatientUser(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      mobileNumber: user.phoneNumber ?? '',
      location: '',
      age: 0,
      bloodGroup: '',
      dateOfBirth: '',
      gender: '',
    );
  }
}