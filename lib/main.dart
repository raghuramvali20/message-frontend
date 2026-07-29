import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:message/core/services/socket_services.dart';
import 'package:message/features/auth/screens/splash_screen.dart';
import 'package:message/core/storage_services/app_storage_services.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/core/constants/app_constants.dart';
import 'package:message/features/auth/controllers/auth_controller.dart';
import 'package:message/features/auth/screens/get_started_screen.dart';
import 'package:message/features/auth/screens/login_screen.dart';
import 'package:message/features/auth/screens/register_screen.dart';
import 'package:message/features/auth/services/auth_services.dart';
import 'package:message/features/auth/services/db_auth_service.dart';
import 'package:message/features/auth/services/fake_auth_service.dart';
import 'package:message/features/auth/state/auth_state.dart';
import 'package:message/features/chat/controllers/chat_controller.dart';
import 'package:message/features/chat/services/db_chat_services.dart';
import 'package:message/features/chat/services/date_time_managing_service.dart';
import 'package:message/features/home/controllers/home_screen_controller.dart';
import 'package:message/features/home/screens/home_screen.dart';
import 'package:message/features/chat/screens/chat_screen.dart';
import 'package:message/features/home/services/db_chat_list_service.dart';
import 'package:message/features/home/services/fake_chat_list_service.dart';
import 'package:message/features/home/state/home_screen_state.dart';
import 'package:message/features/profile/screens/profile_screen.dart';
import 'package:message/features/settings/screens/settings_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final authServices =  DbAuthServices();
  final chatListServices = DbChatListServices();
  final chatServices = DbChatServices();
  final appStorage = AppStorageService();
  final socketService = SocketService();


  runApp(
    MultiProvider(
        providers: [
           ChangeNotifierProvider(
            create: (_) => AuthState()
            ),
            ChangeNotifierProvider(
                create: (_) => HomeScreenState()
            ),
            ChangeNotifierProvider(
                create: (_) => ChatController(chatServices, appStorage, socketService)
            ),


            Provider(
                create: (context) => HomeScreenController(chatListServices, appStorage, socketService, context.read<HomeScreenState>())
            ),
            Provider(create: (context) => AuthController(authServices, appStorage, appStorage, context.read<AuthState>()))
        ],
        child: (MyApp()),
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
      initialRoute: SplashScreen.routeName,
      routes: {
        AppConstants.routeGetStarted: (context) => const GetStartedScreen(),
        AppConstants.routeLogin: (context) => const LoginScreen(),
        AppConstants.routeRegister: (context) => const RegisterScreen(),
        AppConstants.routeHome: (context) => const HomeScreen(),
        SplashScreen.routeName: (context) => const SplashScreen(),
        AppConstants.routeChat: (context) => const ChatScreen(),
        AppConstants.routeProfile: (context) => const ProfileScreen(),
        AppConstants.routeSettings: (context) => const SettingsScreen(),
      },
    );
  }
}

