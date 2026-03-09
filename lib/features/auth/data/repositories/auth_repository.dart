import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/result.dart';

abstract class AuthRepository {
  Future<Result<User>> login({required String email, required String password});
  Future<Result<User>> register({
    required String fullName,
    required String email,
    required String password,
  });
  Future<void> logout();
}
