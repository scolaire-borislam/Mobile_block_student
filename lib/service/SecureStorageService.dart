import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());


  SecureStorage._privateConstructor();

  static final SecureStorage _instance = SecureStorage._privateConstructor();

  // Rest of the class implementation...

  factory SecureStorage() {
    return _instance;
  }


  writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String> readSecureData(String key) async {
    String value = await storage.read(key: key) ?? 'NO_DATA_FOUND';
    print('Data read from secure storage: $value');
    return value;
  }

  deleteSecureData(String key) async {
    await storage.delete(key: key);
  }
}