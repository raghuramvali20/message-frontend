import 'package:flutter/material.dart';
import 'package:message/features/auth/screens/login_screen.dart';
import 'package:message/features/auth/screens/register_screen.dart';


class GetStartedScreen extends StatelessWidget {
  static const String routeName = "get-started-screen"; // Use AppConstants.routeGetStarted

  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo + tagline
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset("assets/icon.png", width: 120),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome to Message\nYour journey starts here!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Buttons stacked vertically
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _customElevateButton(context, "Sign Up"),
                  const SizedBox(height: 12),
                  _customElevateButton(context, "Sign In"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customElevateButton(BuildContext context, String label) {
    return GestureDetector(
        onTap: () {
          if(label == "Sign In"){
            print("clicked");
            Navigator.pushNamed(context, LoginScreen.routeName);
         }if(label == "Sign Up"){
          print("Clicked");
          Navigator.pushNamed(context, RegisterScreen.routeName);
         }
        },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: label == "Sign In"
              ? const Color.fromRGBO(24, 119, 246, 1)
              : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: label == "Sign Up"
                ? const Color.fromRGBO(24, 119, 246, 1)
                : Colors.white,
          ),
        ),
        height: 55,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: label == "Sign Up"
                  ? const Color.fromRGBO(24, 119, 246, 1)
                  : Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
