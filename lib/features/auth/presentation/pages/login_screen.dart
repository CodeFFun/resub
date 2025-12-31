import 'package:flutter/material.dart';
import 'package:resub/core/widgets/my_snackbar.dart';
import 'package:resub/features/dashboard/presentation/pages/home_screen.dart';
import 'package:resub/features/auth/presentation/pages/signup_screen.dart';
import 'package:resub/core/widgets/my_button.dart';
import 'package:resub/core/widgets/my_input_form_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                      "Welcome! Glad to see you again",
                      style: TextStyle(
                        fontSize: 35,
                        color: Color.fromARGB(255, 113, 55, 0),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  MyButton(
                    text: "Login",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform login action
                        showMySnackBar(
                          context: context,
                          message: "Login successful",
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 60),
                  Text("Or Login with"),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform login action
                        showMySnackBar(
                          context: context,
                          message: "Signup successful",
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                    },
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
                    Text("Don't have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Register Now",
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
