import 'package:dartz/dartz.dart';
import 'package:dompetku/core/models/user_model.dart';
import 'package:dompetku/core/errors/exceptions.dart';
import 'package:dompetku/core/errors/failures.dart';
import 'package:dompetku/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:dompetku/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dompetku/features/auth/data/models/auth_session_model.dart';
import 'package:dompetku/features/auth/data/repositories/supabase_auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late SupabaseAuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = SupabaseAuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('SupabaseAuthRepositoryImpl', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tFullName = 'Test User';
    final tUserModel = AuthSessionModel(
      user: UserModel(
        id: '123',
        email: tEmail,
        fullName: tFullName,
        createdAt: DateTime.now(),
      ),
      isBiometricEnabled: false,
      accessToken: 'token123',
    );

    group('signIn', () {
      test(
          'harus mengembalikan AuthSessionEntity ketika login berhasil di remote data source',
          () async {
        // arrange
        when(() =>
                mockRemoteDataSource.signIn(email: tEmail, password: tPassword))
            .thenAnswer((_) async => tUserModel);

        // act
        final result =
            await repository.signIn(email: tEmail, password: tPassword);

        // assert
        expect(result, Right(tUserModel));
        verify(() =>
            mockRemoteDataSource.signIn(email: tEmail, password: tPassword));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test(
          'harus mengembalikan ServerFailure ketika terjadi ServerException di remote data source',
          () async {
        // arrange
        when(() =>
                mockRemoteDataSource.signIn(email: tEmail, password: tPassword))
            .thenThrow(ServerException('Login gagal'));

        // act
        final result =
            await repository.signIn(email: tEmail, password: tPassword);

        // assert
        expect(result, const Left(ServerFailure('Login gagal')));
        verify(() =>
            mockRemoteDataSource.signIn(email: tEmail, password: tPassword));
      });
    });

    group('signUp', () {
      test('harus mengembalikan AuthSessionEntity ketika register berhasil',
          () async {
        // arrange
        when(() => mockRemoteDataSource.signUp(
            fullName: tFullName,
            email: tEmail,
            password: tPassword)).thenAnswer((_) async => tUserModel);

        // act
        final result = await repository.signUp(
            fullName: tFullName, email: tEmail, password: tPassword);

        // assert
        expect(result, Right(tUserModel));
        verify(() => mockRemoteDataSource.signUp(
            fullName: tFullName, email: tEmail, password: tPassword));
      });

      test(
          'harus mengembalikan ServerFailure ketika terjadi ServerException saat register',
          () async {
        // arrange
        when(() => mockRemoteDataSource.signUp(
                fullName: tFullName, email: tEmail, password: tPassword))
            .thenThrow(ServerException('Registrasi gagal'));

        // act
        final result = await repository.signUp(
            fullName: tFullName, email: tEmail, password: tPassword);

        // assert
        expect(result, const Left(ServerFailure('Registrasi gagal')));
      });
    });

    group('Tokens, Sessions dan Status', () {
      test('checkAuthStatus harus memanggil remoteDataSource', () async {
        // arrange
        when(() => mockRemoteDataSource.checkAuthStatus())
            .thenAnswer((_) async => tUserModel);

        // act
        final result = await repository.checkAuthStatus();

        // assert
        expect(result, Right(tUserModel));
        verify(() => mockRemoteDataSource.checkAuthStatus());
      });
    });
  });
}
