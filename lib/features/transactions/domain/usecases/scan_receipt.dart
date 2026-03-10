import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transaction_repository.dart';

class ScanReceiptParams extends Equatable {
  final String imagePath;

  const ScanReceiptParams({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

class ScanReceiptUseCase {
  final TransactionRepository repository;

  ScanReceiptUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
      ScanReceiptParams params) async {
    if (params.imagePath.trim().isEmpty) {
      return const Left(ValidationFailure('File gambar tidak ditemukan'));
    }
    return await repository.scanReceipt(params.imagePath);
  }
}
