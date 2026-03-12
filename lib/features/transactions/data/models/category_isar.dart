import 'package:isar/isar.dart';

import '../../domain/entities/category_entity.dart';

part 'category_isar.g.dart';

@collection
class CategoryIsar {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String name;
  late String icon;

  // Konversi dari Entity ke Isar (untuk menyimpan data)
  static CategoryIsar fromEntity(CategoryEntity entity) {
    return CategoryIsar()
      ..id = entity.id
      ..name = entity.name
      ..icon = entity.icon;
  }

  // Konversi dari Isar ke Entity (untuk dibaca UI)
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      icon: icon,
    );
  }
}
