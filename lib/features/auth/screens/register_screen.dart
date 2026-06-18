import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:message/features/auth/controllers/auth_controller.dart';
import 'package:message/core/storage_services/hive_db.dart';
import 'package:message/features/auth/models/view_model.dart';
import 'package:message/features/home/screens/home_screen.dart';
import 'package:message/features/auth/screens/login_screen.dart';
import 'package:message/features/auth/widgets/auth_screen_widgets.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register-screen"; // Use AppConstants.routeRegister

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String userNameMessage = "";
  String emailMessage = "";
  String passwordMessage = "";
  bool isInvisible = true;
  bool isLoading = false;

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final userNameRegex = RegExp(r'^[a-zA-Z0-9._]+$');

  Future<void> _handleSignUp() async {
    String tempUserNameMessage = "";
    String tempEmailMessage = "";
    String tempPassMessage = "";

    String userName = userNameController.text.trim();
    String email = emailController.text.trim();
    String password = emailController.text.trim();

    if (!userNameRegex.hasMatch(userName)) {
      tempUserNameMessage = "User name only allows letters digits . and _";
    }

    if (!emailRegex.hasMatch(email)) {
      tempEmailMessage = "Enter a valid email address";
    }
    if (password.length < 6) {
      tempPassMessage = "Password must be 6+ characters";
    }
    setState(() {
      userNameMessage = tempUserNameMessage;
      emailMessage = tempEmailMessage;
      passwordMessage = tempPassMessage;
    });

    if (tempPassMessage.isNotEmpty ||
        tempUserNameMessage.isNotEmpty ||
        tempEmailMessage.isNotEmpty)
      return;

    setState(() {
      isLoading = true;
    });

    try {
      final ViewModel result = await AuthController().register(userName, email, password);
      if (!mounted) return;
      if (result.success && result.user != null) {
        await HiveDB().setUserData(result.user!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message), // Backend: "User authorized"
            backgroundColor: Color.fromRGBO(24, 119, 246, 1),
          ),
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      } else {
        // Show exact backend error: "Unauthorized, password is incorrect" etc
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message), // Backend message
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset("assets/icon.png", height: 100),
                  const SizedBox(height: 30),
                  Text(
                    "Welcome to Message",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  AuthScreenWidgets().buildTextField(
                    label: "User Name",
                    controller: userNameController,
                    keyboardType: TextInputType.text,
                    message: userNameMessage,
                    handleSubmit: () => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 15),

                  AuthScreenWidgets().buildTextField(
                    label: "Email",
                    message: emailMessage,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    handleSubmit: () => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 15),
                  AuthScreenWidgets().buildPasswordTextField(
                    label: "Password",
                    message: passwordMessage,
                    isInvisible: isInvisible,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    togglePassword: () => setState(() {
                      isInvisible = !isInvisible;
                    }),
                    handleSubmit: _handleSignUp,
                  ),
                  SizedBox(height: 25),
                  AuthScreenWidgets().buildSubmitButton(
                    "Sign Up",
                    isLoading,
                    _handleSignUp,
                  ),
                  SizedBox(height: 25),
                  _buildTextWithButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextWithButton() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ), // inherits normal text style
        children: [
          const TextSpan(text: "Already have an account? "),
          TextSpan(
            text: "Login",
            style: const TextStyle(
              color: Color.fromRGBO(24, 119, 242, 1),
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
          ),
        ],
      ),
    );
  }
}
