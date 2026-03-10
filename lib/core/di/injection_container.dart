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

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => LocalAuthentication());
}
