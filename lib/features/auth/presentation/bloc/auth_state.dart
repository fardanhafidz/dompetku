import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_session_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthSessionEntity session;
  final bool isLocked;
  const AuthAuthenticated(this.session, {this.isLocked = true});

  @override
  List<Object?> get props => [session, isLocked];

  AuthAuthenticated copyWith({
    AuthSessionEntity? session,
    bool? isLocked,
  }) {
    return AuthAuthenticated(
      session ?? this.session,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class AuthUnauthenticated extends AuthState {}

class AuthNeedsVerification extends AuthState {
  final String email;
  final DateTime? timestamp;
  const AuthNeedsVerification(this.email, {this.timestamp});

  @override
  List<Object?> get props => [email, timestamp];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
