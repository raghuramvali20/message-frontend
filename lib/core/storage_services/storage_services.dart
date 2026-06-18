import 'package:message/core/models/user_model.dart';

abstract class UserStorageService {
    Future<void> saveUser(User user);
    Future<User?> loadUser();
    Future<void> clearUser();
}

abstract class SecureStorageService {
    Future<void> saveToken(String token);
    Future<String?> loadToken();
    Future<void> clearToken();
    // todo: Add keys storage lated;
}

abstract class ThemeStorageService{
    Future<void> saveTheme(bool isDark);
    Future<bool?> loadTheme();
}