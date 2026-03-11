import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/supabase_auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repositories.dart';
import '../../features/auth/domain/usecases/authenticate_biometric.dart';
import '../../features/auth/domain/usecases/check_auth_status.dart';
import '../../features/auth/domain/usecases/log_out.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/domain/usecases/send_otp.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/auth/domain/usecases/pin_use_cases.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

import '../../features/transactions/data/models/category_isar.dart';
import '../../features/transactions/data/models/transaction_isar.dart';
import '../../features/transactions/data/datasources/transaction_local_data_source.dart';
import '../../features/transactions/data/datasources/transaction_remote_data_source.dart';
import '../../features/transactions/data/datasources/mock_transaction_remote_data_source_impl.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/add_transaction.dart';
import '../../features/transactions/domain/usecases/delete_transaction.dart';
import '../../features/transactions/domain/usecases/get_categories.dart';
import '../../features/transactions/domain/usecases/get_transactions.dart';
import '../../features/transactions/domain/usecases/update_transaction.dart';
import '../../features/transactions/presentation/bloc/dashboard_bloc.dart';
import '../../features/transactions/presentation/bloc/transaction_form_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerLazySingleton(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      checkAuthStatus: sl(),
      logOut: sl(),
      sendOtp: sl(),
      verifyOtp: sl(),
      savePin: sl(),
      getPin: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => AuthenticateBiometricUseCase(sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => SavePinUseCase(sl()));
  sl.registerLazySingleton(() => GetPinUseCase(sl()));
  sl.registerLazySingleton(() => HasPinUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => SupabaseAuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      localAuth: sl(),
      sharedPreferences: sl(),
      secureStorage: sl(),
    ),
  );

  // ─── Transaction Feature ────────────────────────────────

  // Bloc (factory = instance baru setiap kali dibuka)
  sl.registerFactory<TransactionFormBloc>(
    () => TransactionFormBloc(
      addTransaction: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
      getCategories: sl(),
    ),
  );

  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(getTransactions: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddTransactionUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTransactionUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTransactionUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));

  // Repository (Local + Remote dengan logic Sync)
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(isar: sl()),
  );

  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => MockTransactionRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // External
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [CategoryIsarSchema, TransactionIsarSchema],
    directory: dir.path,
  );
  sl.registerLazySingleton(() => isar);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => LocalAuthentication());
}

