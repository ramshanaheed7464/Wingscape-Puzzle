import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Storage extends GetxService {
  static Storage get _defaultStorage => Get.find();
  late final SharedPreferences _prefs;
  final Completer<void> _initCompleter = Completer<void>();

  Future<Storage> init() async {
    _prefs = await SharedPreferences.getInstance();
    _initCompleter.complete();
    return this;
  }

  Future<void> _ensureInitialized() async {
    if (!_initCompleter.isCompleted) {
      await _initCompleter.future;
    }
  }

  static Future<bool> setString(String key, String value) async {
    await _defaultStorage._ensureInitialized();
    return await _defaultStorage._prefs.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    await _defaultStorage._ensureInitialized();
    return await _defaultStorage._prefs.setBool(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    await _defaultStorage._ensureInitialized();
    return await _defaultStorage._prefs.setInt(key, value);
  }

  static Future<bool> setDouble(String key, double value) async {
    await _defaultStorage._ensureInitialized();
    return await _defaultStorage._prefs.setDouble(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    await _defaultStorage._ensureInitialized();
    return await _defaultStorage._prefs.setStringList(key, value);
  }

  static Future<bool> containsKey(String key) async {
    await _defaultStorage._ensureInitialized();
    return _defaultStorage._prefs.containsKey(key);
  }

  static Future<String> getString(String key) async {
    await _defaultStorage._ensureInitialized();
    return _defaultStorage._prefs.getString(key) ?? '';
  }

  static Future<bool> getBool(String key) async {
    await _defaultStorage._ensureInitialized();
    return _defaultStorage._prefs.getBool(key) ?? false;
  }

  static Future<int> getInt(String key) async {
    await _defaultStorage._ensureInitialized();
    return _defaultStorage._prefs.getInt(key) ?? 0;
  }

  static Future<double> getDouble(String key) async {
    await _defaultStorage._ensureInitialized();
    return _defaultStorage._prefs.getDouble(key) ?? 0.0;
  }

  static Future<List<String>> getStringList(String key) async {
    await _defaultStorage._ensureInitialized();
    return _defaultStorage._prefs.getStringList(key) ?? [];
  }

  static Future<bool> remove(String key) async {
    await _defaultStorage._ensureInitialized();
    return await _defaultStorage._prefs.remove(key);
  }
}
