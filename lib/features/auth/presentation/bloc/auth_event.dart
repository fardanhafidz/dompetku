import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  const RegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String token;
  final OtpType type;

  const VerifyOtpRequested({
    required this.email,
    required this.token,
    required this.type,
  });

  @override
  List<Object?> get props => [email, token, type];
}

class SendOtpRequested extends AuthEvent {
  final String email;
  const SendOtpRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class LogoutRequested extends AuthEvent {}

class AppLockVerificationRequested extends AuthEvent {
  final String pin;
  const AppLockVerificationRequested(this.pin);

  @override
  List<Object?> get props => [pin];
}

class AppLockBypassed extends AuthEvent {}

class SavePinRequested extends AuthEvent {
  final String pin;
  const SavePinRequested(this.pin);

  @override
  List<Object?> get props => [pin];
}

class BiometricAuthRequested extends AuthEvent {}

class AppLockTriggered extends AuthEvent {}
