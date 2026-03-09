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
  Future<Either<Failure, void>> sendOtp({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.contains('@')) {
      return const Right(null);
    }
    return const Left(ServerFailure('Gagal mengirim OTP: Email tidak valid'));
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> verifyOtp({
    required String email,
    required String otpUrl, // Simulasi input kode dari User OTP link
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulasi jika kode mengandung "123456" sukses
    if (otpUrl.contains('123456')) {
      return Right(_createMockSession(email, 'Verified User'));
    }
    return const Left(ServerFailure('Verifikasi gagal: Kode OTP salah'));
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
