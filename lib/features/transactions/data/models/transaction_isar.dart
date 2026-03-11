import 'package:isar/isar.dart';

import '../../domain/entities/transaction_entity.dart';
import 'category_isar.dart';

part 'transaction_isar.g.dart';

enum TransactionInputSourceIsar { manual, ocr, agent }

@collection
class TransactionIsar {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String userId;

  late double amount;
  late String title;

  late DateTime date;
  late String? notes;
  late String? receiptUrl;

  @enumerated
  late TransactionInputSourceIsar inputSource;

  late DateTime createdAt;
  late DateTime updatedAt;

  late bool syncStatus;

  // Menyimpan relasi ke Category
  final category = IsarLink<CategoryIsar>();

  // Konversi dari Entity ke Isar
  static TransactionIsar fromEntity(TransactionEntity entity) {
    return TransactionIsar()
      ..id = entity.id
      ..userId = entity.userId
      ..amount = entity.amount
      ..title = entity.title
      ..date = entity.date
      ..notes = entity.notes
      ..receiptUrl = entity.receiptUrl
      ..inputSource = _mapInputSourceToIsar(entity.inputSource)
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..syncStatus = entity.syncStatus;
  }

  // Konversi dari Isar ke Entity
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      userId: userId,
      amount: amount,
      title: title,
      category: category.value!.toEntity(), // Ambil data category dari IsarLink
      date: date,
      notes: notes,
      receiptUrl: receiptUrl,
      inputSource: _mapInputSourceFromIsar(inputSource),
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  static TransactionInputSourceIsar _mapInputSourceToIsar(TransactionInputSource source) {
    switch (source) {
      case TransactionInputSource.manual:
        return TransactionInputSourceIsar.manual;
      case TransactionInputSource.ocr:
        return TransactionInputSourceIsar.ocr;
      case TransactionInputSource.agent:
        return TransactionInputSourceIsar.agent;
    }
  }

  static TransactionInputSource _mapInputSourceFromIsar(TransactionInputSourceIsar source) {
    switch (source) {
      case TransactionInputSourceIsar.manual:
        return TransactionInputSource.manual;
      case TransactionInputSourceIsar.ocr:
        return TransactionInputSource.ocr;
      case TransactionInputSourceIsar.agent:
        return TransactionInputSource.agent;
    }
  }
}
