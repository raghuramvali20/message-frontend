import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:message/core/storage_services/app_storage_services.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/core/constants/app_constants.dart';
import 'package:message/features/auth/controllers/auth_controller.dart';
import 'package:message/features/auth/screens/get_started_screen.dart';
import 'package:message/features/auth/screens/login_screen.dart';
import 'package:message/features/auth/screens/register_screen.dart';
import 'package:message/features/auth/services/auth_services.dart';
import 'package:message/features/home/screens/home_screen.dart';
import 'package:message/features/chat/screens/chat_screen.dart';
import 'package:message/features/profile/screens/profile_screen.dart';
import 'package:message/features/settings/screens/settings_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final authServices =  AuthServices();
  final appStorage = AppStorageService();


  runApp(
    MultiProvider(
        providers: [
           ChangeNotifierProvider(
            create: (_) => AuthController(authServices, appStorage, appStorage),
            )
        ]
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Message',
      theme: AppTheme.lightTheme,
      initialRoute: 1 != 1 
          ? AppConstants.routeHome
          : AppConstants.routeGetStarted,
      routes: {
        AppConstants.routeGetStarted: (context) => const GetStartedScreen(),
        AppConstants.routeLogin: (context) => const LoginScreen(),
        AppConstants.routeRegister: (context) => const RegisterScreen(),
        AppConstants.routeHome: (context) => const HomeScreen(),
        AppConstants.routeChat: (context) => const ChatScreen(),
        AppConstants.routeProfile: (context) => const ProfileScreen(),
        AppConstants.routeSettings: (context) => const SettingsScreen(),
      },
    );
  }
}

