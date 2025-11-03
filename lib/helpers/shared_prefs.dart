import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences? _preferences;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // SharedPreferences Methods
  Future<void> setString(String key, String value) async =>
      await _preferences?.setString(key, value);

  String? getString(String key) => _preferences?.getString(key);

  Future<void> setInt(String key, int value) async =>
      await _preferences?.setInt(key, value);

  int? getInt(String key) => _preferences?.getInt(key);

  Future<void> setBool(String key, bool value) async =>
      await _preferences?.setBool(key, value);

  bool? getBool(String key) => _preferences?.getBool(key);

  Future<void> setDouble(String key, double value) async =>
      await _preferences?.setDouble(key, value);

  double? getDouble(String key) => _preferences?.getDouble(key);

  Future<void> setStringList(String key, List<String> value) async =>
      await _preferences?.setStringList(key, value);

  List<String>? getStringList(String key) => _preferences?.getStringList(key);

  Future<void> remove(String key) async => await _preferences?.remove(key);

  Future<void> clear() async => await _preferences?.clear();

  Future<void> setSecureString(String key, String value) async =>
      await _secureStorage.write(key: key, value: value);

  Future<String?> getSecureString(String key) async =>
      await _secureStorage.read(key: key);

  Future<void> removeSecureString(String key) async =>
      await _secureStorage.delete(key: key);
}
