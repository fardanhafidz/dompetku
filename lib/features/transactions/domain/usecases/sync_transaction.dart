import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transaction_repository.dart';

class SyncTransactionsUseCase {
  final TransactionRepository repository;

  SyncTransactionsUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    // Logic deteksi data mana yang belum sinkron akan ada di level Data Layer (Repo/DataSource).
    return await repository.syncUnsyncedTransactions();
  }
}
