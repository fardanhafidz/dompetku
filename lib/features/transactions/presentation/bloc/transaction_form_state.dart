import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';

abstract class TransactionFormState extends Equatable {
  const TransactionFormState();

  @override
  List<Object?> get props => [];
}

class TransactionFormInitial extends TransactionFormState {}

class TransactionFormLoading extends TransactionFormState {}

class CategoriesLoaded extends TransactionFormState {
  final List<CategoryEntity> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class TransactionFormSubmitting extends TransactionFormState {}

class TransactionFormSuccess extends TransactionFormState {
  final String message;

  const TransactionFormSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class TransactionFormFailure extends TransactionFormState {
  final String message;
  final List<CategoryEntity>? categories;

  const TransactionFormFailure({
    required this.message,
    this.categories,
  });

  @override
  List<Object?> get props => [message, categories];
}
