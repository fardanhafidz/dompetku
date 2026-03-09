import 'package:dartz/dartz.dart';
import 'package:dompetku/core/errors/failures.dart';
import 'package:dompetku/features/auth/domain/repositories/auth_repositories.dart';
import 'package:dompetku/features/auth/domain/entities/auth_session_entity.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<Either<Failure, AuthSessionEntity?>> call() async {
    return await repository.checkAuthStatus();
  }
}
