import 'package:dartz/dartz.dart';
import 'package:dompetku/core/errors/failures.dart';
import 'package:dompetku/features/auth/domain/repositories/auth_repositories.dart';
import 'package:dompetku/features/auth/domain/entities/auth_session_entity.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, AuthSessionEntity>> call(
      String fullName, String email, String password) async {
    if (password.length < 8) {
      return Left(ValidationFailure('Password minimal 8 karakter'));
    }

    if (fullName.trim().isEmpty || email.trim().isEmpty) {
      return Left(ValidationFailure('Nama dan Email wajib diisi'));
    }

    return await repository.signUp(fullName, email, password);
  }
}
