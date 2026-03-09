import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dompetku/core/errors/failures.dart';
import 'package:dompetku/features/auth/domain/repositories/auth_repositories.dart';
import 'package:dompetku/features/auth/domain/entities/auth_session_entity.dart';

class VerifyOtpParams extends Equatable {
  final String email;
  final String otpUrl;

  const VerifyOtpParams({
    required this.email,
    required this.otpUrl,
  });

  @override
  List<Object?> get props => [email, otpUrl];
}

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, AuthSessionEntity>> call(
      VerifyOtpParams params) async {
    if (params.email.trim().isEmpty || params.otpUrl.trim().isEmpty) {
      return const Left(
          ValidationFailure('Email dan kode OTP tidak boleh kosong'));
    }

    return await repository.verifyOtp(
      email: params.email,
      otpUrl: params.otpUrl,
    );
  }
}
