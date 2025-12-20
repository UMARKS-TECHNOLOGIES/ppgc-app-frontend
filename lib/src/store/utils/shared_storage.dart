import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._();

  /// Store any JSON-serializable object
  static Future<void> setObject<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(value);
    await prefs.setString(key, jsonString);
  }

  /// Retrieve and decode a JSON object
  static Future<Map<String, dynamic>?> getObject(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Store primitive preferences (bool, int, double, String)
  static Future<void> setPreference<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else {
      throw UnsupportedError('Unsupported preference type');
    }
  }

  /// Store primitive preferences (bool)
  static Future<void> isFirstLaunch(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  /// Retrieve primitive preferences
  static Future<T?> getPreference<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) as T?;
  }

  /// Remove a key
  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// Clear all local data (e.g. logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
