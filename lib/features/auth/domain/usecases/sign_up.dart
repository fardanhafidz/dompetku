import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dompetku/core/errors/failures.dart';
import 'package:dompetku/features/auth/domain/repositories/auth_repositories.dart';
import 'package:dompetku/features/auth/domain/entities/auth_session_entity.dart';

class SignUpParams extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const SignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, AuthSessionEntity>> call(SignUpParams params) async {
    if (params.password.length < 8) {
      return const Left(ValidationFailure('Password minimal 8 karakter'));
    }

    if (params.fullName.trim().isEmpty || params.email.trim().isEmpty) {
      return const Left(ValidationFailure('Nama dan Email wajib diisi'));
    }

    return await repository.signUp(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
  }
}
