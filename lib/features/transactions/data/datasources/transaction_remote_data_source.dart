import '../models/category_model.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<void> addTransaction(TransactionModel transaction);

  Future<List<TransactionModel>> getTransactions({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<void> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String id);

  Future<List<CategoryModel>> getCategories();
}
