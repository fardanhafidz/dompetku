import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

class MockTransactionRepositoryImpl implements TransactionRepository {
  final List<TransactionModel> _transactions = [];

  final List<CategoryModel> _categories = const [
    CategoryModel(
      id: 'cat-1',
      name: 'Food',
      icon: 'restaurant',
      color: '#4CAF50',
      type: 'expense',
    ),
    CategoryModel(
      id: 'cat-2',
      name: 'Transport',
      icon: 'directions_car',
      color: '#2196F3',
      type: 'expense',
    ),
    CategoryModel(
      id: 'cat-3',
      name: 'Groceries',
      icon: 'shopping_cart',
      color: '#FF9800',
      type: 'expense',
    ),
    CategoryModel(
      id: 'cat-4',
      name: 'Coffee',
      icon: 'coffee',
      color: '#795548',
      type: 'expense',
    ),
    CategoryModel(
      id: 'cat-5',
      name: 'Bills',
      icon: 'receipt_long',
      color: '#F44336',
      type: 'expense',
    ),
    CategoryModel(
      id: 'cat-6',
      name: 'Entertainment',
      icon: 'movie',
      color: '#E91E63',
      type: 'expense',
    ),
  ];

  @override
  Future<Either<Failure, void>> addTransaction(
      TransactionEntity transaction) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final model = TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      amount: transaction.amount,
      title: transaction.title,
      category: transaction.category,
      date: transaction.date,
      notes: transaction.notes,
      receiptUrl: transaction.receiptUrl,
      inputSource: transaction.inputSource,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      syncStatus: transaction.syncStatus,
    );

    _transactions.add(model);
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var result = List<TransactionModel>.from(_transactions);

    if (categoryId != null) {
      result = result.where((t) => t.category.id == categoryId).toList();
    }
    if (startDate != null) {
      result = result.where((t) => t.date.isAfter(startDate)).toList();
    }
    if (endDate != null) {
      result = result.where((t) => t.date.isBefore(endDate)).toList();
    }

    result.sort((a, b) => b.date.compareTo(a.date));
    return Right(result);
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
      TransactionEntity transaction) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index == -1) {
      return Left(
          ServerFailure('Transaksi dengan ID ${transaction.id} tidak ditemukan'));
    }

    _transactions[index] = TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      amount: transaction.amount,
      title: transaction.title,
      category: transaction.category,
      date: transaction.date,
      notes: transaction.notes,
      receiptUrl: transaction.receiptUrl,
      inputSource: transaction.inputSource,
      createdAt: transaction.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: false,
    );

    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _transactions.indexWhere((t) => t.id == id);
    if (index == -1) {
      return Left(ServerFailure('Transaksi dengan ID $id tidak ditemukan'));
    }

    _transactions.removeAt(index);
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Right(_categories);
  }

  @override
  Future<Either<Failure, void>> syncUnsyncedTransactions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const Right(null);
  }

  @override
  Future<Either<Failure, Map<String, double>>> getTransactionSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    double totalExpense = 0;
    double totalIncome = 0;

    for (final t in _transactions) {
      if (t.category.type == 'expense') {
        totalExpense += t.amount;
      } else {
        totalIncome += t.amount;
      }
    }

    return Right({
      'total_expense': totalExpense,
      'total_income': totalIncome,
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> scanReceipt(
      String imagePath) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right({
      'amount': 25000,
      'title': 'Mock Receipt Merchant',
      'date': '2026-03-11T12:00:00.000Z',
    });
  }
}
