import 'package:flutter/material.dart';
import 'package:resub/common/my_snackbar.dart';
import 'package:resub/screen/home_screen.dart';
import 'package:resub/screen/login_screen.dart';
import 'package:resub/widgets/my_button.dart';
import 'package:resub/widgets/my_input_form_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
                  MyInputFormField(
                    controller: _confirmPasswordController,
                    labelText: "Confirm Password",
                    icon: Icon(Icons.key),
                    obscureText: true,
                  ),
                  SizedBox(height: 15),
                  SizedBox(height: 25),
                  MyButton(
                    text: "Register",
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
                  ),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
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
