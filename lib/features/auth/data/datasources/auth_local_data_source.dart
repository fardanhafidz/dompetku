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
  Future<void> savePin(String pin);
  Future<String?> getPin();
  Future<bool> hasPin();
  Future<void> clearPin();
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
  Future<void> savePin(String pin) async {
    try {
      await secureStorage.write(key: kUserPinKey, value: pin);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String?> getPin() async {
    try {
      return await secureStorage.read(key: kUserPinKey);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> hasPin() async {
    try {
      final pin = await secureStorage.read(key: kUserPinKey);
      return pin != null && pin.isNotEmpty;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearPin() async {
    try {
      await secureStorage.delete(key: kUserPinKey);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearLocalData() async {
    try {
      await sharedPreferences.remove(kBiometricEnabledKey);
      await secureStorage.delete(key: kUserPinKey);
    } catch (e) {
      throw CacheException();
    }
  }
}
