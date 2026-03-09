import 'package:dartz/dartz.dart';
import 'package:dompetku/features/transactions/domain/entities/transaction_entity.dart';
import '../../../../core/errors/failures.dart';
import 'package:dompetku/features/transactions/domain/entities/category_entity.dart';

abstract class TransactionRepository {
  // Transactions
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction);

  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, void>> updateTransaction(
      TransactionEntity transaction);

  Future<Either<Failure, void>> deleteTransaction(String id);

  // Sync
  Future<Either<Failure, void>> syncUnsyncedTransactions();

  // Categories
  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  // Summary
  Future<Either<Failure, Map<String, double>>> getTransactionSummary({
    DateTime? startDate,
    DateTime? endDate,
  });

  // AI OCR
  Future<Either<Failure, Map<String, dynamic>>> scanReceipt(String imagePath);
}
