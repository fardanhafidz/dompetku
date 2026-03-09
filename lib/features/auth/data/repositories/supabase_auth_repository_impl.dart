import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show OtpType;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class SupabaseAuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  SupabaseAuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthSessionEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return const Left(
          ServerFailure('Terjadi kesalahan yang tidak terduga saat login'));
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return const Left(
          ServerFailure('Terjadi kesalahan yang tidak terduga saat register'));
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity?>> checkAuthStatus() async {
    try {
      final userModel = await remoteDataSource.checkAuthStatus();
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return const Left(ServerFailure('Gagal mengecek status autentikasi'));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticateBiometric() async {
    try {
      final isSuccess = await localDataSource.authenticateBiometric();
      return Right(isSuccess);
    } on CacheException {
      return const Left(
          CacheFailure('Biometrik tidak tersedia atau gagal divalidasi'));
    } catch (e) {
      return const Left(
          CacheFailure('Terjadi kesalahan saat otentikasi biometrik'));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp({required String email}) async {
    try {
      await remoteDataSource.sendOtp(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengirim OTP'));
    } catch (e) {
      return const Left(ServerFailure(
          'Terjadi kesalahan yang tidak terduga saat mengirim OTP'));
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> verifyOtp({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    try {
      final userModel = await remoteDataSource.verifyOtp(
        email: email,
        token: token,
        type: type,
      );
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal memverifikasi OTP'));
    } catch (e) {
      return const Left(ServerFailure(
          'Terjadi kesalahan yang tidak terduga saat verifikasi OTP'));
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await remoteDataSource.logOut();
      await localDataSource.clearLocalData();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return const Left(ServerFailure('Terjadi kesalahan saat logout'));
    }
  }
}
