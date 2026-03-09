import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failure.dart';
import 'auth_repository.dart';

/// STEP 2: Implementasi Nyata
/// Di sini kita melakukan request ke server/database (Supabase).
class SupabaseAuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepositoryImpl(this._client);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Memanggil fungsi bawaan Supabase
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        return Right(response.user!); // Berhasil
      } else {
        return const Left(AuthFailure('Login failed: User is null'));
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message)); // Error spesifik dari Supabase (misal: password salah)
    } catch (e) {
      return Left(AuthFailure(e.toString())); // Error lainnya
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      if (response.user != null) {
        return Right(response.user!);
      } else {
        return const Left(AuthFailure('Registration failed: User is null'));
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return Right(_client.auth.currentUser);
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
