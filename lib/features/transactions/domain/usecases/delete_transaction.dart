import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transaction_repository.dart';

class DeleteTransactionParams extends Equatable {
  final String id;

  const DeleteTransactionParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(DeleteTransactionParams params) async {
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('ID transaksi tidak valid'));
    }

    return await repository.deleteTransaction(params.id);
  }
}
