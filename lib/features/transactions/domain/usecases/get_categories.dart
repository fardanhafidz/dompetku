import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/transaction_repository.dart';

class GetCategoriesParams extends Equatable {
  const GetCategoriesParams();

  @override
  List<Object?> get props => [];
}

class GetCategoriesUseCase {
  final TransactionRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call(
      GetCategoriesParams params) async {
    return await repository.getCategories();
  }
}
