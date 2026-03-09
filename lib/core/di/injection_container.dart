import 'package:dompetku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dompetku/features/auth/data/repositories/auth_repository.dart';
import 'package:dompetku/features/auth/data/repositories/supabase_auth_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => AuthBloc(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => SupabaseAuthRepositoryImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => Supabase.instance.client);
}
