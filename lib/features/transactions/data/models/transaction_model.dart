import '../../domain/entities/transaction_entity.dart';
import 'category_model.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.title,
    required super.category,
    required super.date,
    super.notes,
    super.receiptUrl,
    required super.inputSource,
    required super.createdAt,
    required super.updatedAt,
    super.syncStatus = false,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      title: json['title'] as String,
      category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      inputSource: _parseInputSource(json['input_source'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      syncStatus: json['sync_status'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'title': title,
      'category_id': category.id,
      'date': date.toIso8601String(),
      'notes': notes,
      'receipt_url': receiptUrl,
      'input_source': inputSource.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sync_status': syncStatus,
    };
  }

  static TransactionInputSource _parseInputSource(String source) {
    switch (source) {
      case 'ocr':
        return TransactionInputSource.ocr;
      case 'agent':
        return TransactionInputSource.agent;
      case 'manual':
      default:
        return TransactionInputSource.manual;
    }
  }
}
