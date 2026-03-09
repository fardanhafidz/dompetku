import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> register({
    required String fullName,
    required String email,
    required String password,
  });
  Future<Either<Failure, User?>> getCurrentUser();
  Future<void> logout();
}
