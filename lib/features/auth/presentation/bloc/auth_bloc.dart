import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/log_out.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/pin_use_cases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final CheckAuthStatusUseCase _checkAuthStatus;
  final LogOutUseCase _logOut;
  final SendOtpUseCase _sendOtp;
  final VerifyOtpUseCase _verifyOtp;
  final SavePinUseCase _savePin;
  final GetPinUseCase _getPin;

  AuthBloc({
    required SignInUseCase signIn,
    required SignUpUseCase signUp,
    required CheckAuthStatusUseCase checkAuthStatus,
    required LogOutUseCase logOut,
    required SendOtpUseCase sendOtp,
    required VerifyOtpUseCase verifyOtp,
    required SavePinUseCase savePin,
    required GetPinUseCase getPin,
  })  : _signIn = signIn,
        _signUp = signUp,
        _checkAuthStatus = checkAuthStatus,
        _logOut = logOut,
        _sendOtp = sendOtp,
        _verifyOtp = verifyOtp,
        _savePin = savePin,
        _getPin = getPin,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AppLockVerificationRequested>(_onAppLockVerificationRequested);
    on<AppLockBypassed>(_onAppLockBypassed);
    on<SavePinRequested>(_onSavePinRequested);
    on<AppLockTriggered>(_onAppLockTriggered);
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
      (session) {
        if (session.accessToken == null) {
          emit(AuthNeedsVerification(event.email, timestamp: DateTime.now()));
        } else {
          emit(AuthAuthenticated(session));
        }
      },
    );
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _verifyOtp(
      VerifyOtpParams(
        email: event.email,
        token: event.token,
        type: event.type,
      ),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (session) => emit(AuthAuthenticated(session)),
    );
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _sendOtp(SendOtpParams(email: event.email));
    result.fold(
      (failure) {
        debugPrint('SendOtp Failure: ${failure.message}');
        emit(AuthFailure(failure.message));
      },
      (_) {
        debugPrint('SendOtp Success for ${event.email}');
        emit(AuthNeedsVerification(event.email, timestamp: DateTime.now()));
      },
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

  Future<void> _onAppLockVerificationRequested(
    AppLockVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final pinResult = await _getPin();
      pinResult.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (storedPin) {
          if (storedPin == event.pin) {
            emit(currentState.copyWith(isLocked: false));
          } else {
            emit(const AuthFailure('PIN yang Anda masukkan salah'));
          }
        },
      );
    }
  }

  Future<void> _onAppLockBypassed(
    AppLockBypassed event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      emit(currentState.copyWith(isLocked: false));
    }
  }

  Future<void> _onSavePinRequested(
    SavePinRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _savePin(event.pin);
    final currentState = state;
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) {
        if (currentState is AuthAuthenticated) {
          emit(AuthAuthenticated(
            currentState.session.copyWith(hasPin: true),
            isLocked: false,
          ));
        }
      },
    );
  }

  void _onAppLockTriggered(
    AppLockTriggered event,
    Emitter<AuthState> emit,
  ) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      emit(currentState.copyWith(isLocked: true));
    }
  }
}
