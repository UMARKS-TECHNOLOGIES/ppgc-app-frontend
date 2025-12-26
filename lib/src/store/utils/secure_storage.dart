import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // 1. Private constructor
  StorageService._privateConstructor();

  // 2. Static instance
  static final StorageService _instance = StorageService._privateConstructor();

  // 3. Public factory to access the instance
  factory StorageService() => _instance;

  // --- CONFIGURATION ---

  // Secure Storage Instance
  final _secureStorage = const FlutterSecureStorage();

  // Keys for data identification
  static const _keyAccessToken = 'auth_access_token';
  static const _keyProfileId = 'user_profile_id';

  // Android Options: Encrypts the SharedPrefs on Android
  AndroidOptions _getAndroidOptions() => const AndroidOptions();

  // iOS Options: standard keychain access
  IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  // --- SECURE STORAGE METHODS (For Tokens) ---

  /// Save the user authentication token securely
  Future<void> saveUserToken(String token) async {
    await _secureStorage.write(
      key: _keyAccessToken,
      value: token,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  /// Retrieve the user authentication token
  Future<String?> getUserToken() async {
    return await _secureStorage.read(
      key: _keyAccessToken,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  /// Delete the user token (Useful for logout)
  Future<void> deleteUserToken() async {
    await _secureStorage.delete(
      key: _keyAccessToken,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  // --- SHARED PREFERENCES METHODS (For Profile Key) ---

  /// Save the profile key/ID to standard Shared Preferences
  Future<void> saveProfileKey(String profileKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileId, profileKey);
  }

  /// Retrieve the profile key/ID
  Future<String?> getProfileKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileId);
  }

  /// Delete the profile key
  Future<void> deleteProfileKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProfileId);
  }

  // --- HELPER METHODS ---

  /// Checks if the user is "logged in" by verifying if a token exists
  Future<bool> get hasToken async {
    var token = await getUserToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all stored data (Useful for full logout)
  Future<void> clearAll() async {
    // Clear secure storage
    await _secureStorage.deleteAll(
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );

    // Clear shared preferences profile key
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProfileId);
    // Or use prefs.clear() if you want to wipe ALL shared_prefs
  }
}

// utils
void handleLoginSuccess(String apiToken, String userId) async {
  final storage = StorageService();

  // Save token securely
  await storage.saveUserToken(apiToken);

  // Save profile ID to shared prefs
  await storage.saveProfileKey(userId);
}

void logout() async {
  await StorageService().clearAll();
  // Navigate back to login screen
}
