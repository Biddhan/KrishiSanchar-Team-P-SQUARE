import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUtil {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';

  /// Save token
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _keyToken, value: token);
  }

  /// Read token
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: _keyToken);
  }

  /// Delete token
  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: _keyToken);
  }

  /// Save any key-value pair
  static Future<void> saveValue(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Read any value
  static Future<String?> getValue(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Delete a specific value
  static Future<void> deleteValue(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Clear all data
  static Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
