import 'package:flutter/material.dart';
import 'package:message/core/storage_services/app_storage_services.dart';
import 'package:message/features/auth/screens/get_started_screen.dart';
import 'package:message/features/home/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final storage = AppStorageService();
    final isAuth = await storage.isAuthenticated();

    if (!mounted) return;

    if (isAuth) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, GetStartedScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
