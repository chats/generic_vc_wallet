// services/storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  final _secureStorage = const FlutterSecureStorage();

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // SharedPreferences Methods
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> removeKey(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clearPrefs() async {
    return await _prefs.clear();
  }

  // Secure Storage Methods
  Future<void> saveSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> removeSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // Utility Methods
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }

  Future<bool> hasSecureKey(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null;
  }
}