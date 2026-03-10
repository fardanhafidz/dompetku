import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class AddTransactionParams extends Equatable {
  final TransactionEntity transaction;

  const AddTransactionParams({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(AddTransactionParams params) async {
    // Validasi sederhana: Amount gak boleh 0 atau negatif
    if (params.transaction.amount <= 0) {
      return const Left(
          ValidationFailure('Jumlah transaksi harus lebih dari 0'));
    }

    // Validasi: Judul gak boleh kosong
    if (params.transaction.title.trim().isEmpty) {
      return const Left(
          ValidationFailure('Judul transaksi tidak boleh kosong'));
    }

    return await repository.addTransaction(params.transaction);
  }
}
