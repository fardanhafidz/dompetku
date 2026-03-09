import 'package:dompetku/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:dompetku/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks(
  [
    AuthRemoteDataSource,
    AuthLocalDataSource,
    SupabaseClient,
    GoTrueClient,
    SupabaseQueryBuilder,
    PostgrestFilterBuilder,
  ],
)
void main() {}
