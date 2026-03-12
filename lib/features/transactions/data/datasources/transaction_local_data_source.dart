import 'package:isar/isar.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../models/category_isar.dart';
import '../models/transaction_isar.dart';

abstract class TransactionLocalDataSource {
  Future<List<CategoryEntity>> getCategories();
  Future<void> cacheCategories(List<CategoryEntity> categories);
  
  Future<List<TransactionEntity>> getTransactions();
  Future<void> cacheTransactions(List<TransactionEntity> transactions);
  
  Future<void> addTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String id);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Isar isar;

  TransactionLocalDataSourceImpl({required this.isar});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categories = await isar.categoryIsars.where().findAll();
    return categories.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> cacheCategories(List<CategoryEntity> categories) async {
    final isarCategories = categories.map((e) => CategoryIsar.fromEntity(e)).toList();
    await isar.writeTxn(() async {
      await isar.categoryIsars.putAll(isarCategories);
    });
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final transactions = await isar.transactionIsars.where().sortByDateDesc().findAll();
    for (var t in transactions) {
      await t.category.load();
      if (t.category.value == null) {
         // Fallback manual if broken relational link to avoid crash
         t.category.value = CategoryIsar()
            ..id = 'unknown'
            ..name = 'Unknown'
            ..icon = 'help_outline';
      }
    }
    return transactions.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> cacheTransactions(List<TransactionEntity> transactions) async {
    final isarTransactions = transactions.map((t) => TransactionIsar.fromEntity(t)).toList();
    await isar.writeTxn(() async {
      await isar.transactionIsars.putAll(isarTransactions);
      
      // Link categories for each transaction
      for (var i = 0; i < isarTransactions.length; i++) {
        final categoryIsar = await isar.categoryIsars.filter().idEqualTo(transactions[i].category.id).findFirst();
        if (categoryIsar != null) {
          isarTransactions[i].category.value = categoryIsar;
          await isarTransactions[i].category.save();
        }
      }
    });
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    final isarTransaction = TransactionIsar.fromEntity(transaction);
    await isar.writeTxn(() async {
      await isar.transactionIsars.put(isarTransaction);
      
      final categoryIsar = await isar.categoryIsars.filter().idEqualTo(transaction.category.id).findFirst();
      if (categoryIsar != null) {
        isarTransaction.category.value = categoryIsar;
        await isarTransaction.category.save();
      }
    });
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    final existing = await isar.transactionIsars.filter().idEqualTo(transaction.id).findFirst();
    if (existing != null) {
      final isarTransaction = TransactionIsar.fromEntity(transaction);
      isarTransaction.isarId = existing.isarId; // Retain Isar ID
      
      await isar.writeTxn(() async {
        await isar.transactionIsars.put(isarTransaction);
        
        final categoryIsar = await isar.categoryIsars.filter().idEqualTo(transaction.category.id).findFirst();
        if (categoryIsar != null) {
          isarTransaction.category.value = categoryIsar;
          await isarTransaction.category.save();
        }
      });
    } else {
      // If it doesn't exist, just add it
      await addTransaction(transaction);
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await isar.writeTxn(() async {
      await isar.transactionIsars.filter().idEqualTo(id).deleteAll();
    });
  }
}
