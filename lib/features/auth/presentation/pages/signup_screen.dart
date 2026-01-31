import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/core/utils/snackbar_utils.dart';
import 'package:resub/core/widgets/my_button.dart';
import 'package:resub/core/widgets/my_input_form_field.dart';
import 'package:resub/features/auth/presentation/pages/first_onboarding_screen.dart';
import 'package:resub/features/auth/presentation/state/auth_state.dart';
import 'package:resub/features/auth/presentation/view_models/auth_view_model.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final formState = _formKey.currentState;
    if (formState != null && formState.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .register(
            userName: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  void _navigateToFirstOnboardingScreen() {
    AppRoutes.pushReplacement(context, const FirstOnboardingScreen());
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(
          context,
          'Registration successful! Please complete your profile.',
        );
        AppRoutes.pushReplacement(
          context,
          FirstOnboardingScreen(email: _emailController.text.trim()),
        );
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(
                      "Hello! Register to get started",
                      style: TextStyle(
                        fontSize: 35,
                        color: Color.fromARGB(255, 113, 55, 0),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  MyInputFormField(
                    controller: _usernameController,
                    labelText: "Username",
                    icon: Icon(Icons.person),
                  ),
                  SizedBox(height: 15),
                  MyInputFormField(
                    controller: _emailController,
                    labelText: "Email",
                    inputType: TextInputType.emailAddress,
                    icon: Icon(Icons.email),
                  ),
                  SizedBox(height: 15),
                  MyInputFormField(
                    controller: _passwordController,
                    labelText: "Password",
                    icon: Icon(Icons.key),
                    obscureText: true,
                  ),
                  SizedBox(height: 15),
                  SizedBox(height: 25),
                  MyButton(text: "Register", onPressed: _handleSignup),
                  SizedBox(height: 25),
                  Text("Or Register with"),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    child: Image.asset(
                      'assets/icons/g.png',
                      height: 25,
                      width: 25,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: _navigateToFirstOnboardingScreen,
                      child: Text(
                        "Login Now",
                        style: TextStyle(
                          color: Color.fromARGB(255, 113, 55, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
