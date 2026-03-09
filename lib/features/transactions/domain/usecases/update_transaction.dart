import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransactionParams extends Equatable {
  final TransactionEntity transaction;

  const UpdateTransactionParams({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(UpdateTransactionParams params) async {
    // Validasi dasar tetap perlu
    if (params.transaction.amount <= 0) {
      return const Left(
          ValidationFailure('Jumlah transaksi harus lebih dari 0'));
    }

    if (params.transaction.title.trim().isEmpty) {
      return const Left(
          ValidationFailure('Judul transaksi tidak boleh kosong'));
    }

    return await repository.updateTransaction(params.transaction);
  }
}
