import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auth_session_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
  });

  Future<AuthSessionModel?> checkAuthStatus();

  Future<void> logOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<AuthSessionModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user == null) {
        throw ServerException('Registrasi gagal, sistem tidak merespon');
      }

      return AuthSessionModel.fromSupabase(
        session: response.session,
        supabaseUser: response.user,
        userData: {
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
          'is_biometric_enabled': false,
        },
        isBiometricEnabled: false,
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException('Login gagal, Email atau Password salah');
      }

      // 2. Fetch data public
      final userData = await supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return AuthSessionModel.fromSupabase(
        session: response.session,
        supabaseUser: response.user,
        userData: userData,
        isBiometricEnabled: userData['is_biometric_enabled'] ?? false,
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthSessionModel?> checkAuthStatus() async {
    try {
      final session = supabaseClient.auth.currentSession;
      final user = supabaseClient.auth.currentUser;

      if (session == null || user == null) {
        return null;
      }

      // Fetch profile profil terbaru
      final userData = await supabaseClient
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      return AuthSessionModel.fromSupabase(
        session: session,
        supabaseUser: user,
        userData: userData,
        isBiometricEnabled: userData?['is_biometric_enabled'] ?? false,
      );
    } catch (e) {
      throw ServerException('Gagal memuat status autentikasi');
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException('Gagal melakukan logout');
    }
  }
}
