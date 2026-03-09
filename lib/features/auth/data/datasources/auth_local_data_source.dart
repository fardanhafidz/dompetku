import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';

const String kBiometricEnabledKey = 'BIOMETRIC_ENABLED_KEY';

abstract class AuthLocalDataSource {
  Future<bool> authenticateBiometric();
  Future<void> setBiometricEnabled(bool isEnabled);
  Future<bool> getBiometricEnabled();
  Future<void> clearLocalData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalAuthentication localAuth;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.localAuth,
    required this.sharedPreferences,
  });

  @override
  Future<bool> authenticateBiometric() async {
    try {
      final isAvailable = await localAuth.canCheckBiometrics &&
          await localAuth.isDeviceSupported();

      if (!isAvailable) {
        throw CacheException();
      }

      return await localAuth.authenticate(
        localizedReason: 'Pindai biometrik Anda untuk mengakses Dompetku',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> getBiometricEnabled() async {
    try {
      return sharedPreferences.getBool(kBiometricEnabledKey) ?? false;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> setBiometricEnabled(bool isEnabled) async {
    try {
      await sharedPreferences.setBool(kBiometricEnabledKey, isEnabled);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearLocalData() async {
    try {
      await sharedPreferences.remove(kBiometricEnabledKey);
    } catch (e) {
      throw CacheException();
    }
  }
}
