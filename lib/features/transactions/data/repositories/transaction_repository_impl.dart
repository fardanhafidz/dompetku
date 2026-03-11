import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';
import '../datasources/transaction_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction) async {
    try {
      // 1. Simpan ke local (Isar) dulu agar langsung tampil di UI (offline support)
      final transactionToSave = TransactionEntity(
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
        syncStatus: false, // Belum sync
      );
      
      await localDataSource.addTransaction(transactionToSave);

      // 2. Coba kirim ke Remote (Supabase/Mock)
      try {
        final model = TransactionModel(
          id: transactionToSave.id,
          userId: transactionToSave.userId,
          amount: transactionToSave.amount,
          title: transactionToSave.title,
          category: CategoryModel(
            id: transactionToSave.category.id,
            name: transactionToSave.category.name,
            icon: transactionToSave.category.icon,
            color: transactionToSave.category.color,
            type: transactionToSave.category.type,
          ),
          date: transactionToSave.date,
          notes: transactionToSave.notes,
          receiptUrl: transactionToSave.receiptUrl,
          inputSource: transactionToSave.inputSource,
          createdAt: transactionToSave.createdAt,
          updatedAt: transactionToSave.updatedAt,
          syncStatus: true,
        );
        
        await remoteDataSource.addTransaction(model);
        
        // 3. Jika berhasil ke remote, update syncStatus di local
        final syncedTransaction = TransactionEntity(
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
          syncStatus: true, // Sudah tersinkron
        );
        await localDataSource.updateTransaction(syncedTransaction);
      } catch (e) {
        // Jika gagal ke remote, abaikan (sudah aman di local)
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      
      try {
        await remoteDataSource.deleteTransaction(id);
      } catch (e) {
         // Abaikan error remote
      }
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      // 1. Cek local dulu
      final localCategories = await localDataSource.getCategories();
      
      if (localCategories.isNotEmpty) {
        // 2. Jika local ada, kembalikan local dan fetch remote di background
        _syncCategoriesToLocal();
        return Right(localCategories);
      }

      // 3. Jika local kosong, tunggu dari remote lalu simpan
      final remoteCategories = await remoteDataSource.getCategories();
      await localDataSource.cacheCategories(remoteCategories);
      
      return Right(remoteCategories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _syncCategoriesToLocal() async {
    try {
      final remoteCategories = await remoteDataSource.getCategories();
      await localDataSource.cacheCategories(remoteCategories);
    } catch (e) {
       // Ignore background error
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // 1. Selalu tampilkan dari local DB agar cepat & bisa offline
      final localTransactions = await localDataSource.getTransactions();
      
      // 2. Trigger background sync
      _syncTransactionsToLocal();

      // 3. Filter data local yang ditarik
      var filtered = localTransactions;
      if (categoryId != null) {
        filtered = filtered.where((t) => t.category.id == categoryId).toList();
      }
      if (startDate != null) {
        filtered = filtered.where((t) => t.date.isAfter(startDate.subtract(const Duration(days: 1)))).toList();
      }
      if (endDate != null) {
        filtered = filtered.where((t) => t.date.isBefore(endDate.add(const Duration(days: 1)))).toList();
      }

      return Right(filtered);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  Future<void> _syncTransactionsToLocal() async {
    try {
      final remoteTransactions = await remoteDataSource.getTransactions();
      await localDataSource.cacheTransactions(remoteTransactions);
    } catch (e) {
       // Ignore background error
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(TransactionEntity transaction) async {
    try {
      // Format 1: Update local
      final transactionToSave = TransactionEntity(
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
      
      await localDataSource.updateTransaction(transactionToSave);

      try {
        // Format 2: Update remote
        final model = TransactionModel(
          id: transactionToSave.id,
          userId: transactionToSave.userId,
          amount: transactionToSave.amount,
          title: transactionToSave.title,
          category: CategoryModel(
            id: transactionToSave.category.id,
            name: transactionToSave.category.name,
            icon: transactionToSave.category.icon,
            color: transactionToSave.category.color,
            type: transactionToSave.category.type,
          ),
          date: transactionToSave.date,
          notes: transactionToSave.notes,
          receiptUrl: transactionToSave.receiptUrl,
          inputSource: transactionToSave.inputSource,
          createdAt: transactionToSave.createdAt,
          updatedAt: transactionToSave.updatedAt,
          syncStatus: true,
        );
        
        await remoteDataSource.updateTransaction(model);
        
        // Format 3: Tandai sudah tersinkron
        final syncedTransaction = TransactionEntity(
          id: transactionToSave.id,
          userId: transactionToSave.userId,
          amount: transactionToSave.amount,
          title: transactionToSave.title,
          category: transactionToSave.category,
          date: transactionToSave.date,
          notes: transactionToSave.notes,
          receiptUrl: transactionToSave.receiptUrl,
          inputSource: transactionToSave.inputSource,
          createdAt: transactionToSave.createdAt,
          updatedAt: transactionToSave.updatedAt,
          syncStatus: true,
        );
        await localDataSource.updateTransaction(syncedTransaction);
      } catch (e) {
        // Jika gagal ke remote, abaikan
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getTransactionSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return const Right({'income': 0.0, 'expense': 0.0, 'total': 0.0});
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> scanReceipt(String imagePath) async {
    return const Left(ServerFailure('OCR not implemented yet'));
  }

  @override
  Future<Either<Failure, void>> syncUnsyncedTransactions() async {
    return const Right(null);
  }
}
