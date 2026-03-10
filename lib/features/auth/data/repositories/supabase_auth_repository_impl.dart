import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show OtpType;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_session_model.dart';
import '../../../../core/models/user_model.dart';

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
      final hasPin = await localDataSource.hasPin();
      return Right(AuthSessionModel(
        user: userModel.user as UserModel,
        isBiometricEnabled: userModel.isBiometricEnabled,
        hasPin: hasPin,
        accessToken: userModel.accessToken,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(
          ServerFailure('Terjadi kesalahan yang tidak terduga saat login: $e'));
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
      final hasPin = await localDataSource.hasPin();
      return Right(AuthSessionModel(
        user: userModel.user as UserModel,
        isBiometricEnabled: userModel.isBiometricEnabled,
        hasPin: hasPin,
        accessToken: userModel.accessToken,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(
          'Terjadi kesalahan yang tidak terduga saat register: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity?>> checkAuthStatus() async {
    try {
      final userModel = await remoteDataSource.checkAuthStatus();
      if (userModel == null) return const Right(null);

      final hasPin = await localDataSource.hasPin();
      return Right(AuthSessionModel(
        user: userModel.user as UserModel,
        isBiometricEnabled: userModel.isBiometricEnabled,
        hasPin: hasPin,
        accessToken: userModel.accessToken,
      ));
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
      final hasPin = await localDataSource.hasPin();
      return Right(AuthSessionModel(
        user: userModel.user as UserModel,
        isBiometricEnabled: userModel.isBiometricEnabled,
        hasPin: hasPin,
        accessToken: userModel.accessToken,
      ));
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

  @override
  Future<Either<Failure, void>> savePin({required String pin}) async {
    try {
      await localDataSource.savePin(pin);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Gagal menyimpan PIN'));
    }
  }

  @override
  Future<Either<Failure, String?>> getPin() async {
    try {
      final pin = await localDataSource.getPin();
      return Right(pin);
    } catch (e) {
      return const Left(CacheFailure('Gagal mengambil PIN'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasPin() async {
    try {
      final hasPin = await localDataSource.hasPin();
      return Right(hasPin);
    } catch (e) {
      return const Left(CacheFailure('Gagal mengecek status PIN'));
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity?>> getCurrentUser() async {
    return checkAuthStatus();
  }

  @override
  Future<Either<Failure, void>> setBiometricEnabled(bool isEnabled) async {
    try {
      await localDataSource.setBiometricEnabled(isEnabled);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Gagal menyimpan preferensi biometrik'));
    }
  }

  @override
  Future<Either<Failure, bool>> getBiometricEnabled() async {
    try {
      final isEnabled = await localDataSource.getBiometricEnabled();
      return Right(isEnabled);
    } catch (e) {
      return const Left(CacheFailure('Gagal mengambil preferensi biometrik'));
    }
  }
}
