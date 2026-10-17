import 'package:yodoctor/modules/auth/models/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> signInWithEmail({
    required String identifier,
    required String password,
  });

  Future<void> signOut();

  Future<bool> isAuthenticated();
}