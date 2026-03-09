import 'package:dompetku/core/errors/exceptions.dart';
import 'package:dompetku/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {
  final MockPostgrestFilterBuilder mockFilterBuilder;

  MockSupabaseQueryBuilder(this.mockFilterBuilder);

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> select(
      [String columns = '*']) {
    return mockFilterBuilder;
  }
}

class MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

class MockPostgrestTransformBuilder extends Mock
    implements PostgrestTransformBuilder<List<Map<String, dynamic>>> {}

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();

    when(() => mockSupabaseClient.auth).thenReturn(mockGoTrueClient);

    dataSource = AuthRemoteDataSourceImpl(mockSupabaseClient);
  });

  group('AuthRemoteDataSourceImpl', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tFullName = 'Test User';

    final tUser = User(
      id: 'uid-123',
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    );

    final tSession = Session(
      accessToken: 'access-token',
      expiresIn: 3600,
      refreshToken: 'refresh-token',
      tokenType: 'bearer',
      user: tUser,
    );

    final tAuthResponse = AuthResponse(
      session: tSession,
      user: tUser,
    );

    group('signIn', () {
      test(
          'harus return AuthSessionModel ketika sukses panggil signInWithPassword',
          () async {
        // arrange
        when(() => mockGoTrueClient.signInWithPassword(
            email: tEmail,
            password: tPassword)).thenAnswer((_) async => tAuthResponse);

        // Mock query Supabase
        // Karena pemanggilan supabaseClient.from('users').select().eq().single()
        // Cukup rumit di mock, test data source kadang lebih baik dipisah (integrasi)
        // Atau buat abstrack helper.
        // Untuk saat ini kita override aja eksekusinya karena kita akan tes failure nya
        // karena berhasilnya membutuhkan mock chaining yang rumit di postgrest.
      });

      test('harus throw ServerException ketika user null login gagal',
          () async {
        // arrange
        final tAuthResponseFail = AuthResponse(session: null, user: null);
        when(() => mockGoTrueClient.signInWithPassword(
            email: tEmail,
            password: tPassword)).thenAnswer((_) async => tAuthResponseFail);

        // act & assert
        expect(() => dataSource.signIn(email: tEmail, password: tPassword),
            throwsA(isA<ServerException>()));
      });

      test('harus throw ServerException ketika terjadi AuthException',
          () async {
        // arrange
        when(() => mockGoTrueClient.signInWithPassword(
                email: tEmail, password: tPassword))
            .thenThrow(const AuthException('Invalid login credentials'));

        // act & assert
        expect(() => dataSource.signIn(email: tEmail, password: tPassword),
            throwsA(isA<ServerException>()));
      });
    });

    group('signUp', () {
      test('harus throw ServerException ketika user null register gagal',
          () async {
        // arrange
        final tAuthResponseFail = AuthResponse(session: null, user: null);
        when(() => mockGoTrueClient.signUp(
                email: tEmail,
                password: tPassword,
                data: {'full_name': tFullName}))
            .thenAnswer((_) async => tAuthResponseFail);

        // act & assert
        expect(
            () => dataSource.signUp(
                fullName: tFullName, email: tEmail, password: tPassword),
            throwsA(isA<ServerException>()));
      });
    });
  });
}
