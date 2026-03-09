import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dompetku/core/errors/failures.dart';
import 'package:dompetku/features/auth/domain/repositories/auth_repositories.dart';

class SendOtpParams extends Equatable {
  final String email;

  const SendOtpParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<Either<Failure, void>> call(SendOtpParams params) async {
    if (params.email.trim().isEmpty) {
      return const Left(ValidationFailure('Email tidak boleh kosong'));
    }

    if (!params.email.contains('@')) {
      return const Left(ValidationFailure('Format email tidak valid'));
    }

    return await repository.sendOtp(
      email: params.email,
    );
  }
}
