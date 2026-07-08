import 'package:yodoctor/core/models/patient/patient_user.dart';

abstract class AuthService {
  Future<PatientUser?> signIn();

  Future<void> signOut();

  Future<PatientUser?> getCurrentUser();

  Future<String?> getIdToken();

  bool get isLoggedIn;

  Future<bool> isAuthenticated();


}