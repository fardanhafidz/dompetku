import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/update_transaction.dart';
import 'transaction_form_event.dart';
import 'transaction_form_state.dart';

class TransactionFormBloc
    extends Bloc<TransactionFormEvent, TransactionFormState> {
  final AddTransactionUseCase _addTransaction;
  final UpdateTransactionUseCase _updateTransaction;
  final DeleteTransactionUseCase _deleteTransaction;
  final GetCategoriesUseCase _getCategories;

  TransactionFormBloc({
    required AddTransactionUseCase addTransaction,
    required UpdateTransactionUseCase updateTransaction,
    required DeleteTransactionUseCase deleteTransaction,
    required GetCategoriesUseCase getCategories,
  })  : _addTransaction = addTransaction,
        _updateTransaction = updateTransaction,
        _deleteTransaction = deleteTransaction,
        _getCategories = getCategories,
        super(TransactionFormInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SubmitTransaction>(_onSubmitTransaction);
    on<UpdateExistingTransaction>(_onUpdateTransaction);
    on<DeleteExistingTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<TransactionFormState> emit,
  ) async {
    emit(TransactionFormLoading());

    final result = await _getCategories(const GetCategoriesParams());
    result.fold(
      (failure) => emit(TransactionFormFailure(message: failure.message)),
      (categories) => emit(CategoriesLoaded(categories: categories)),
    );
  }

  Future<void> _onSubmitTransaction(
    SubmitTransaction event,
    Emitter<TransactionFormState> emit,
  ) async {
    emit(TransactionFormSubmitting());

    final now = DateTime.now();
    final transaction = TransactionEntity(
      id: const Uuid().v4(),
      userId: 'current-user',
      amount: event.amount,
      title: event.title,
      category: event.category,
      date: event.date,
      notes: event.notes,
      inputSource: TransactionInputSource.manual,
      createdAt: now,
      updatedAt: now,
    );

    final result = await _addTransaction(
      AddTransactionParams(transaction: transaction),
    );

    result.fold(
      (failure) => emit(TransactionFormFailure(message: failure.message)),
      (_) => emit(const TransactionFormSuccess(
          message: 'Transaksi berhasil disimpan!')),
    );
  }

  Future<void> _onUpdateTransaction(
    UpdateExistingTransaction event,
    Emitter<TransactionFormState> emit,
  ) async {
    emit(TransactionFormSubmitting());

    final result = await _updateTransaction(
      UpdateTransactionParams(transaction: event.transaction),
    );

    result.fold(
      (failure) => emit(TransactionFormFailure(message: failure.message)),
      (_) => emit(const TransactionFormSuccess(
          message: 'Transaksi berhasil diperbarui!')),
    );
  }

  Future<void> _onDeleteTransaction(
    DeleteExistingTransaction event,
    Emitter<TransactionFormState> emit,
  ) async {
    emit(TransactionFormSubmitting());

    final result = await _deleteTransaction(
      DeleteTransactionParams(id: event.transactionId),
    );

    result.fold(
      (failure) => emit(TransactionFormFailure(message: failure.message)),
      (_) => emit(
          const TransactionFormSuccess(message: 'Transaksi berhasil dihapus!')),
    );
  }
}
