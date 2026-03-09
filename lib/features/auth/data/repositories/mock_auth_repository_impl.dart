import 'package:dartz/dartz.dart';

import '../../../../core/entities/user_entity.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repositories.dart';

/// Implementasi Mock (Palsu) untuk AuthRepository
/// Berguna untuk keperluan testing UI tanpa nembak langsung API Supabase.
class MockAuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, AuthSessionEntity>> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading server

    if (email == 'user@test.com' && password == 'password123') {
      return Right(_createMockSession(email, 'Budi Mock'));
    }
    return const Left(ServerFailure('Login gagal: Email atau Password salah'));
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading server

    if (email.contains('@')) {
      return Right(_createMockSession(email, fullName));
    }
    return const Left(ServerFailure('Registrasi gagal: Email tidak valid'));
  }

  @override
  Future<Either<Failure, AuthSessionEntity?>> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Default kembalikan null tandanya belum login
    return const Right(null);
  }

  @override
  Future<Either<Failure, bool>> authenticateBiometric() async {
    await Future.delayed(const Duration(seconds: 1));
    // Selalu dianggap berhasil dalam mock
    return const Right(true);
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Right(null);
  }

  AuthSessionEntity _createMockSession(String email, String fullName) {
    return AuthSessionEntity(
      user: UserEntity(
        id: 'mock-uuid-12345',
        email: email,
        fullName: fullName,
        createdAt: DateTime.now(),
      ),
      isBiometricEnabled: false,
      accessToken: 'mock-jwt-token-abcd',
    );
  }
}
