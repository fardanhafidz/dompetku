import '../models/category_model.dart';
import '../models/transaction_model.dart';
import 'transaction_remote_data_source.dart';

class MockTransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final List<TransactionModel> _transactions = [];

  final List<CategoryModel> _categories = const [
    CategoryModel(
      id: 'cat-1',
      name: 'Food',
      icon: 'restaurant',
      color: '#4CAF50',
    ),
    CategoryModel(
      id: 'cat-2',
      name: 'Transport',
      icon: 'directions_car',
      color: '#2196F3',
    ),
    CategoryModel(
      id: 'cat-3',
      name: 'Groceries',
      icon: 'shopping_cart',
      color: '#FF9800',
    ),
    CategoryModel(
      id: 'cat-4',
      name: 'Coffee',
      icon: 'coffee',
      color: '#795548',
    ),
    CategoryModel(
      id: 'cat-5',
      name: 'Bills',
      icon: 'receipt_long',
      color: '#F44336',
    ),
    CategoryModel(
      id: 'cat-6',
      name: 'Entertainment',
      icon: 'movie',
      color: '#E91E63',
    ),
  ];

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _transactions.add(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _transactions.removeWhere((element) => element.id == id);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _categories;
  }

  @override
  Future<List<TransactionModel>> getTransactions({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var result = _transactions;
    if (categoryId != null) {
      result = result.where((t) => t.category.id == categoryId).toList();
    }
    return result;
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _transactions.indexWhere((element) => element.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
    }
  }
}
