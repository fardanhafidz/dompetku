import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_session_entity.dart';
import '../repositories/auth_repositories.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, AuthSessionEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(
      email: params.email,
      token: params.token,
      type: params.type,
    );
  }
}

class VerifyOtpParams {
  final String email;
  final String token;
  final OtpType type;

  VerifyOtpParams({
    required this.email,
    required this.token,
    required this.type,
  });
}
