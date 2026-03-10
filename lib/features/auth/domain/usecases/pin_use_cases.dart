import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repositories.dart';

class SavePinUseCase {
  final AuthRepository repository;

  SavePinUseCase(this.repository);

  Future<Either<Failure, void>> call(String pin) {
    return repository.savePin(pin: pin);
  }
}

class GetPinUseCase {
  final AuthRepository repository;

  GetPinUseCase(this.repository);

  Future<Either<Failure, String?>> call() {
    return repository.getPin();
  }
}

class HasPinUseCase {
  final AuthRepository repository;

  HasPinUseCase(this.repository);

  Future<Either<Failure, bool>> call() {
    return repository.hasPin();
  }
}
