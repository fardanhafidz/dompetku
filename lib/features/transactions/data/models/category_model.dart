import '../../domain/entities/category_entity.dart';

/// CategoryModel adalah versi "data layer" dari CategoryEntity.
///
/// KENAPA PERLU MODEL TERPISAH DARI ENTITY?
/// ─────────────────────────────────────────
/// Entity (domain layer) = aturan bisnis murni. Dia TIDAK TAHU soal JSON, API,
///                          atau database. Dia hanya tahu: "kategori punya id,
///                          name, icon, color, type."
///
/// Model  (data layer)   = tahu cara konversi data dari/ke format luar (JSON).
///                          Dia EXTEND Entity, jadi semua property-nya sama,
///                          tapi DITAMBAH kemampuan fromJson / toJson.
///
/// ANALOGI: Entity itu seperti "kontrak kerja" — isinya aturan.
///          Model itu seperti "pegawai" yang mengerjakan kontrak itu +
///          bisa baca/tulis dokumen (JSON).
///
/// POLA YANG SAMA SEPERTI AUTH:
/// AuthSessionEntity (domain) ←── AuthSessionModel (data) extends-nya

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.color,
    required super.type,
  });

  /// Membuat CategoryModel dari JSON (data dari Supabase / API)
  ///
  /// Contoh JSON yang masuk:
  /// {
  ///   "id": "cat-1",
  ///   "name": "Food",
  ///   "icon": "🍔",
  ///   "color": "#FF5733",
  ///   "type": "expense"
  /// }
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      type: json['type'] as String,
    );
  }

  /// Mengubah CategoryModel ke JSON (untuk dikirim ke Supabase / API)
  ///
  /// Kebalikan dari fromJson — dipakai saat kita ingin MENYIMPAN data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'type': type,
    };
  }
}
