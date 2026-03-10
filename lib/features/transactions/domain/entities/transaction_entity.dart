import 'package:equatable/equatable.dart';
import 'category_entity.dart';

enum TransactionInputSource { manual, ocr, agent }

class TransactionEntity extends Equatable {
  final String id;
  final String userId;
  final double amount;
  final String title;
  final CategoryEntity category;
  final DateTime date;
  final String? notes;
  final String? receiptUrl;
  final TransactionInputSource inputSource;

  // Flag Metadata untuk Offline-First Sync
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool syncStatus; // false = butuh sync ke cloud, true = aman tersinkron

  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.amount,
    required this.title,
    required this.category,
    required this.date,
    this.notes,
    this.receiptUrl,
    required this.inputSource,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = false,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        amount,
        title,
        category,
        date,
        notes,
        receiptUrl,
        inputSource,
        createdAt,
        updatedAt,
        syncStatus,
      ];
}
