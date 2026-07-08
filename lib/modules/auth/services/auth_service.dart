import 'package:yodoctor/core/models/auth/login_response.dart';

abstract class AuthService {
  Future<LoginResponse> signInWithEmail({
    required String identifier,
    required String password,
  });

  Future<void> signOut();

  Future<bool> isAuthenticated();
}