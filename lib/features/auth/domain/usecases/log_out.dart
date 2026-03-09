import 'package:dartz/dartz.dart';
import 'package:dompetku/core/errors/failures.dart';
import 'package:dompetku/features/auth/domain/repositories/auth_repositories.dart';

class LogOutUseCase {
  final AuthRepository repository;

  LogOutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logOut();
  }
}
