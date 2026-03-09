import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionSummaryParams extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;

  const GetTransactionSummaryParams({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class GetTransactionSummaryUseCase {
  final TransactionRepository repository;

  GetTransactionSummaryUseCase(this.repository);

  Future<Either<Failure, Map<String, double>>> call(
      GetTransactionSummaryParams params) async {
    // Validasi rentang tanggal
    if (params.startDate != null && params.endDate != null) {
      if (params.startDate!.isAfter(params.endDate!)) {
        return const Left(
            ValidationFailure('Rentang tanggal ringkasan tidak valid'));
      }
    }

    return await repository.getTransactionSummary(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
