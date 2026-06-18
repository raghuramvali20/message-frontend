class AppConstants {
  // API
  static const String baseUrl = 'http://localhost:3000/api';
  static const int requestTimeout = 30; // seconds
  static const int retryAttempts = 3;

  // Socket
  static const String socketUrl = 'http://localhost:3000';
  static const int socketReconnectDelay = 5; // seconds

  // Storage Keys
  static const String storageKeyJwt = 'jwt_token';
  static const String storageKeyUser = 'user_data';

  // Route Names (centralized for easy refactoring)
  static const String routeGetStarted = 'get-started-screen';
  static const String routeRegister = 'register-screen';
  static const String routeLogin = 'login-screen';
  static const String routeHome = 'home-screen';
  static const String routeChat = 'chat-screen';
  static const String routeProfile = 'profile-screen';
  static const String routeSettings = 'settings-screen';

  // Validation
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;

  // UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
}

class ApiEndpoints {
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String validateKey = '/health/key-validator';

  static const String chats = '/chats';
  static const String chatsByUser = '$chats/by-user';
  static const String chatsByChat = '$chats/by-chat';

  static const String messages = '/message';
  static const String sendMessage = '$messages/send';

  static const String users = '/users';
  static const String searchUsers = '$users/search';
}

class ErrorMessages {
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String invalidInput = 'Invalid input. Please check your data.';
  static const String unauthorized = 'Unauthorized. Please login again.';
  static const String notFound = 'Resource not found.';
  static const String unknownError = 'Something went wrong. Please try again.';
}

class SuccessMessages {
  static const String messageSent = 'Message sent successfully';
  static const String loginSuccess = 'Login successful';
  static const String registerSuccess = 'Registration successful';
  static const String profileUpdated = 'Profile updated';
}
