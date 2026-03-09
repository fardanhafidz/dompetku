import 'package:dartz/dartz.dart';
import 'package:dompetku/core/errors/failures.dart';
import 'package:dompetku/features/auth/domain/repositories/auth_repositories.dart';

class AuthenticateBiometricUseCase {
  final AuthRepository repository;

  AuthenticateBiometricUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.authenticateBiometric();
  }
}
