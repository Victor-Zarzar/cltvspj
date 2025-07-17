import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorageKeys { apiKey }

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() => _instance;

  static late final FlutterSecureStorage _secureStorage;

  SecureStorageService._internal();

  static void init() {
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  Future<String?> getApiKey() async =>
      await _secureStorage.read(key: SecureStorageKeys.apiKey.name);

  Future<void> setApiKey(String apiKey) async => await _secureStorage.write(
    key: SecureStorageKeys.apiKey.name,
    value: apiKey,
  );

  Future<bool> hasApiKey() async =>
      await _secureStorage.containsKey(key: SecureStorageKeys.apiKey.name);
}
