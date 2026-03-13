import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category_model.dart';
import '../models/transaction_model.dart';
import 'transaction_remote_data_source.dart';

class SupabaseTransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final SupabaseClient supabaseClient;

  SupabaseTransactionRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await supabaseClient.from('transactions').insert(transaction.toJson());
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await supabaseClient.from('transactions').delete().eq('id', id);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await supabaseClient.from('categories').select();
    return (response as List).map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactions({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Simplified query with join to fetch categories
    final joinedResponse = await supabaseClient
        .from('transactions')
        .select('*, categories(*)')
        .order('date', ascending: false);

    return (joinedResponse as List).map((json) {
      // Map 'categories' to 'category' to match our model
      final map = Map<String, dynamic>.from(json);
      map['category'] = map['categories'];
      return TransactionModel.fromJson(map);
    }).toList();
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await supabaseClient
        .from('transactions')
        .update(transaction.toJson())
        .eq('id', transaction.id);
  }
}
