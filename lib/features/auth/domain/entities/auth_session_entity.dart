import 'package:equatable/equatable.dart';
import '../../../../core/entities/user_entity.dart';

class AuthSessionEntity extends Equatable {
  final UserEntity user;
  final bool isBiometricEnabled;
  final bool hasPin;
  final String? accessToken;

  const AuthSessionEntity({
    required this.user,
    required this.isBiometricEnabled,
    this.hasPin = false,
    this.accessToken,
  });

  @override
  List<Object?> get props => [user, isBiometricEnabled, hasPin, accessToken];

  AuthSessionEntity copyWith({
    UserEntity? user,
    bool? isBiometricEnabled,
    bool? hasPin,
    String? accessToken,
  }) {
    return AuthSessionEntity(
      user: user ?? this.user,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      hasPin: hasPin ?? this.hasPin,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
