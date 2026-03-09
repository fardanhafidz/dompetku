import 'package:equatable/equatable.dart';
import '../../../../core/entities/user_entity.dart';

class AuthSessionEntity extends Equatable {
  final UserEntity user;
  final bool isBiometricEnabled;
  final String? accessToken;

  const AuthSessionEntity({
    required this.user,
    required this.isBiometricEnabled,
    this.accessToken,
  });

  @override
  List<Object?> get props => [user, isBiometricEnabled, accessToken];
}
