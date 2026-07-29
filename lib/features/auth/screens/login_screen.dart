import 'package:flutter/material.dart';
import 'package:message/core/widgets/snack_bar_helper.dart';
import 'package:message/features/auth/controllers/auth_controller.dart';
import 'package:message/features/auth/state/auth_state.dart';
import 'package:message/features/home/screens/home_screen.dart';
import 'package:message/features/auth/screens/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:message/features/auth/widgets/auth_screen_widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login-screen"; // Use AppConstants.routeLogin
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String emailMessage = "";
  String passwordMessage = "";
  bool isInvisible= true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    String tempEmailMsg = "";
    String tempPassMsg = "";
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!emailRegex.hasMatch(email)) {
      tempEmailMsg = "Enter a valid email address";
    }
    if (password.length < 6) {
      tempPassMsg = "Password must be 6+ characters";
    }

    setState(() {
      emailMessage = tempEmailMsg;
      passwordMessage = tempPassMsg;
    });

    if (tempEmailMsg.isNotEmpty || tempPassMsg.isNotEmpty) return;

    // 2. Call API
    try {
      final authController = context.read<AuthController>();
      await authController.login(email, password);
      if (!mounted) return;

      // 3. Only save if success == true AND user exists
      final auth = context.read<AuthState>();
      if (auth.user != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      } else if (auth.error != null) {
        SnackBarHelper.showError(context, auth.error!);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final auth = context.watch<AuthState>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset("assets/icon.png", height: 100),
                  const SizedBox(height: 30),
                  const Text(
                    "Welcome back to Message",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                 AuthScreenWidgets().buildTextField(
                    label: "Email",
                    message: emailMessage,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    handleSubmit:()=> FocusScope.of(context).nextFocus()
                    ),

                  const SizedBox(height: 15),
                  AuthScreenWidgets().buildPasswordTextField(
                    label: "Password",
                    message: passwordMessage,
                    isInvisible: isInvisible,
                    controller:  passwordController,
                    keyboardType:TextInputType.text,
                    handleSubmit: _handleLogin,
                    togglePassword: ()=>{
                        setState(() {
                           isInvisible = !isInvisible;
                            }) 
                    }
                  ),
                  const SizedBox(height: 25),
                  AuthScreenWidgets().buildSubmitButton("Login", auth.loading, _handleLogin),

                  const SizedBox(height: 25,),

                  _buildTextWithButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  

  Widget _buildTextWithButton(){
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 15,
          color: Colors.black
        ), // inherits normal text style
        children: [
          const TextSpan(text: "Don't have an account? "),
          TextSpan(
            text: "Sign Up",
            style: const TextStyle(
              color: Color.fromRGBO(24, 119, 242, 1),
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
               Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
              },
          ),
        ],
      ),
    );
  }
}


