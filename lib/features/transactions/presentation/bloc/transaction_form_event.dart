import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';

abstract class TransactionFormEvent extends Equatable {
  const TransactionFormEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends TransactionFormEvent {}

class SubmitTransaction extends TransactionFormEvent {
  final double amount;
  final String title;
  final CategoryEntity category;
  final DateTime date;
  final String? notes;

  const SubmitTransaction({
    required this.amount,
    required this.title,
    required this.category,
    required this.date,
    this.notes,
  });

  @override
  List<Object?> get props => [amount, title, category, date, notes];
}

class UpdateExistingTransaction extends TransactionFormEvent {
  final TransactionEntity transaction;

  const UpdateExistingTransaction({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class DeleteExistingTransaction extends TransactionFormEvent {
  final String transactionId;

  const DeleteExistingTransaction({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}
