import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/result.dart';
import 'auth_repository.dart';

/// STEP 2: Implementasi Nyata
/// Di sini kita melakukan request ke server/database (Supabase).
class SupabaseAuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepositoryImpl(this._client);

  @override
  Future<Result<User>> login({
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
        return Success(response.user!); // Berhasil
      } else {
        return const Failure('Login failed: User is null');
      }
    } on AuthException catch (e) {
      return Failure(e.message); // Error spesifik dari Supabase (misal: password salah)
    } catch (e) {
      return Failure(e.toString()); // Error lainnya
    }
  }

  @override
  Future<Result<User>> register({
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
        return Success(response.user!);
      } else {
        return const Failure('Registration failed: User is null');
      }
    } on AuthException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
