import '../../domain/entities/transaction_entity.dart';
import 'category_model.dart';

/// TransactionModel adalah versi "data layer" dari TransactionEntity.
///
/// KONSEP YANG SAMA SEPERTI CategoryModel:
/// - Entity (domain) hanya tahu aturan bisnis
/// - Model (data) tahu cara baca/tulis JSON
///
/// PERHATIKAN:
/// TransactionEntity punya field `category` bertipe CategoryEntity.
/// Tapi di Model, kita konversi jadi CategoryModel (karena Model tahu fromJson).
/// Ini disebut "nested model" — model di dalam model.
///
/// ALUR DATA:
/// ┌──────────┐     fromJson()     ┌──────────────────┐
/// │   JSON   │ ──────────────────►│ TransactionModel  │
/// │ (dari DB)│                    │ (data layer)      │
/// └──────────┘                    └──────────────────┘
///                                          │
///                                          │ karena extends TransactionEntity,
///                                          │ bisa langsung dipakai sebagai Entity
///                                          ▼
///                                 ┌──────────────────┐
///                                 │ TransactionEntity │
///                                 │ (domain layer)    │
///                                 └──────────────────┘

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

  /// Membuat TransactionModel dari JSON (data dari Supabase)
  ///
  /// Contoh JSON yang masuk dari Supabase:
  /// {
  ///   "id": "txn-123",
  ///   "user_id": "user-1",
  ///   "amount": 50000,
  ///   "title": "Makan Siang",
  ///   "category": { "id": "cat-1", "name": "Food", ... },
  ///   "date": "2026-03-11T12:30:00.000Z",
  ///   "notes": "Di warteg dekat kampus",
  ///   "receipt_url": null,
  ///   "input_source": "manual",
  ///   "created_at": "2026-03-11T10:00:00.000Z",
  ///   "updated_at": "2026-03-11T10:00:00.000Z",
  ///   "sync_status": true
  /// }
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      title: json['title'] as String,
      // Nested model! Category datang sebagai JSON object di dalam JSON transaksi
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

  /// Mengubah TransactionModel ke JSON (untuk dikirim ke Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'title': title,
      // Kita perlu cast category ke CategoryModel untuk akses toJson()
      // Karena field `category` di Entity bertipe CategoryEntity (parent class)
      'category_id': category.id,
      'date': date.toIso8601String(),
      'notes': notes,
      'receipt_url': receiptUrl,
      'input_source': inputSource.name, // enum → string ("manual", "ocr", "agent")
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sync_status': syncStatus,
    };
  }

  /// Helper: konversi string dari JSON ke enum TransactionInputSource
  ///
  /// JSON menyimpan sebagai string ("manual"), kita perlu ubah ke enum
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
