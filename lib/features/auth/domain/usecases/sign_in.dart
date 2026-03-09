import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dompetku/core/errors/failures.dart';
import 'package:dompetku/features/auth/domain/repositories/auth_repositories.dart';
import 'package:dompetku/features/auth/domain/entities/auth_session_entity.dart';

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, AuthSessionEntity>> call(SignInParams params) async {
    if (params.email.trim().isEmpty || params.password.isEmpty) {
      return const Left(
          ValidationFailure('Email dan Password tidak boleh kosong'));
    }

    return await repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
