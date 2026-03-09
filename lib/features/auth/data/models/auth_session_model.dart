import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:dompetku/core/models/user_model.dart';
import 'package:dompetku/features/auth/domain/entities/auth_session_entity.dart';

class AuthSessionModel extends AuthSessionEntity {
  const AuthSessionModel({
    required UserModel super.user,
    required super.isBiometricEnabled,
    super.accessToken,
  });

  factory AuthSessionModel.fromSupabase({
    required supabase.Session? session,
    required supabase.User? supabaseUser,
    required Map<String, dynamic>? userData,
    bool isBiometricEnabled = false,
  }) {
    if (supabaseUser == null) {
      throw Exception('Supabase user is null');
    }

    final userModel = userData != null
        ? UserModel.fromJson(userData)
        : UserModel(
            id: supabaseUser.id,
            email: supabaseUser.email ?? '',
            fullName: '',
            createdAt: DateTime.now(),
          );

    return AuthSessionModel(
      user: userModel,
      isBiometricEnabled: isBiometricEnabled,
      accessToken: session?.accessToken,
    );
  }
}
