import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/storage_services/storage_services.dart';

class AppStorageService implements SecureStorageService, UserStorageService, ThemeStorageService {
  // Example using Hive + SecureStorage together

  @override
  Future<void> saveToken(String token) async {
    await FlutterSecureStorage().write(key: 'jwt', value: token);
  }

  @override
  Future<String?> loadToken() async {
    return await FlutterSecureStorage().read(key: 'jwt');
  }

  @override
  Future<void> clearToken() async {
    await FlutterSecureStorage().delete(key: 'jwt');
  }

//   @override
//   Future<void> saveKeys(String publicKey, String privateKey) async {
//     await FlutterSecureStorage().write(key: 'publicKey', value: publicKey);
//     await FlutterSecureStorage().write(key: 'privateKey', value: privateKey);
//   }

//   @override
//   Future<Map<String, String>?> loadKeys() async {
//     final pub = await FlutterSecureStorage().read(key: 'publicKey');
//     final priv = await FlutterSecureStorage().read(key: 'privateKey');
//     if (pub != null && priv != null) {
//       return {'publicKey': pub, 'privateKey': priv};
//     }
//     return null;
//   }

  @override
  Future<void> saveUser(User user) async {
    final box = await Hive.openBox('userBox');
    await box.put('user', user.toJson());
  }

  @override
  Future<User?> loadUser() async {
    final box = await Hive.openBox('userBox');
    final data = box.get('user');
    if (data != null) {
      return User.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    final box = await Hive.openBox('userBox');
    await box.delete('user');
  }

  @override
  Future<void> saveTheme(bool isDark) async {
    final themeData = await SharedPreferences.getInstance();
    themeData.setBool('darkTheme', isDark);
  }

  @override
  Future<bool?> loadTheme() async {
    final themeData = await SharedPreferences.getInstance();
    return themeData.getBool('darkTheme');
  }
}
