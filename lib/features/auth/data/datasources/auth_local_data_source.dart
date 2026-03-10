import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';

const String kBiometricEnabledKey = 'BIOMETRIC_ENABLED_KEY';
const String kUserPinKey = 'USER_PIN_KEY';

abstract class AuthLocalDataSource {
  Future<bool> authenticateBiometric();
  Future<void> setBiometricEnabled(bool isEnabled);
  Future<bool> getBiometricEnabled();
  Future<void> savePin(String pin, String email);
  Future<String?> getPin(String email);
  Future<bool> hasPin(String email);
  Future<void> clearPin(String email);
  Future<void> clearLocalData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalAuthentication localAuth;
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({
    required this.localAuth,
    required this.sharedPreferences,
    required this.secureStorage,
  });

  String _getPinKey(String email) => 'USER_PIN_KEY_$email';

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
  Future<void> savePin(String pin, String email) async {
    try {
      await secureStorage.write(key: _getPinKey(email), value: pin);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String?> getPin(String email) async {
    try {
      return await secureStorage.read(key: _getPinKey(email));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> hasPin(String email) async {
    try {
      final pin = await secureStorage.read(key: _getPinKey(email));
      return pin != null && pin.isNotEmpty;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearPin(String email) async {
    try {
      await secureStorage.delete(key: _getPinKey(email));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearLocalData() async {
    try {
      await sharedPreferences.remove(kBiometricEnabledKey);
      await secureStorage.deleteAll();
    } catch (e) {
      throw CacheException();
    }
  }
}
