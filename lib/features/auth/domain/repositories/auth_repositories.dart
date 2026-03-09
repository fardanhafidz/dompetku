import 'package:dartz/dartz.dart';
import 'package:dompetku/core/errors/failures.dart';

import '../entities/auth_session_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSessionEntity>> signUp({
    required String fullName,
    required String email,
    required String password,
  });
  Future<Either<Failure, AuthSessionEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthSessionEntity?>> checkAuthStatus();

  Future<Either<Failure, bool>> authenticateBiometric();

  Future<Either<Failure, void>> logOut();
}
