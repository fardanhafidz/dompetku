import 'package:dartz/dartz.dart';
import 'package:dompetku/core/errors/failures.dart';

import '../entities/auth_session_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSessionEntity>> signUp({
    required String fullName,
    required String email,
    required String password,
  });
  Future<AuthSessionEntity> signIn({required String email, required password});
  Future<AuthSessionEntity?> checkAuthStatus();
  Future<bool> authenticateBiometric();
  Future<void> logOut();
}
