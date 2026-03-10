import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repositories.dart';

class SavePinUseCase {
  final AuthRepository repository;

  SavePinUseCase(this.repository);

  Future<Either<Failure, void>> call(String pin, String email) {
    return repository.savePin(pin: pin, email: email);
  }
}

class GetPinUseCase {
  final AuthRepository repository;

  GetPinUseCase(this.repository);

  Future<Either<Failure, String?>> call(String email) {
    return repository.getPin(email);
  }
}

class HasPinUseCase {
  final AuthRepository repository;

  HasPinUseCase(this.repository);

  Future<Either<Failure, bool>> call(String email) {
    return repository.hasPin(email);
  }
}
