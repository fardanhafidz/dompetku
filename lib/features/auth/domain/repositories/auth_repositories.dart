import '../entities/auth_session_entity.dart';

abstract class AuthRepository {
  Future<AuthSessionEntity> signUp(
      String fullName, String email, String password);
  Future<AuthSessionEntity> signIn(String email, String password);
  Future<AuthSessionEntity?> checkAuthStatus();
  Future<bool> authenticateBiometric();
  Future<void> logOut();
}
