import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/log_out.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final CheckAuthStatusUseCase _checkAuthStatus;
  final LogOutUseCase _logOut;

  AuthBloc({
    required SignInUseCase signIn,
    required SignUpUseCase signUp,
    required CheckAuthStatusUseCase checkAuthStatus,
    required LogOutUseCase logOut,
  })  : _signIn = signIn,
        _signUp = signUp,
        _checkAuthStatus = checkAuthStatus,
        _logOut = logOut,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _checkAuthStatus();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (session) {
        if (session != null) {
          emit(AuthAuthenticated(session));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (session) => emit(AuthAuthenticated(session)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signUp(
      SignUpParams(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (session) => emit(AuthAuthenticated(session)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _logOut();
    emit(AuthUnauthenticated());
  }
}
