import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsParams extends Equatable {
  final String? categoryId;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetTransactionsParams({
    this.categoryId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [categoryId, startDate, endDate];
}

class GetTransactionsUseCase {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call(
      GetTransactionsParams params) async {
    if (params.startDate != null && params.endDate != null) {
      if (params.startDate!.isAfter(params.endDate!)) {
        return const Left(ValidationFailure(
            'Tanggal awal tidak boleh lebih besar dari tanggal akhir'));
      }
    }
    // Passing langsung parameter ke repository untuk di-query ke Database!
    return await repository.getTransactions(
      categoryId: params.categoryId,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
