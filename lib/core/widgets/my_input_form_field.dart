import 'package:flutter/material.dart';

class MyInputFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? inputType;
  final String labelText;
  final bool? obscureText;
  final String? hintText;
  final Icon? icon;

  const MyInputFormField({
    super.key,
    required this.controller,
    this.inputType,
    required this.labelText,
    this.hintText,
    this.obscureText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintText: hintText,
        prefixIcon: icon,
        fillColor: Colors.grey.shade300,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $labelText";
        }

        // Email validation
        if (labelText.toLowerCase() == "email") {
          if (!value.contains('@')) {
            return "Please enter a valid email";
          }
        }

        // Password validation
        if (labelText.toLowerCase() == "password") {
          final passwordRegex = RegExp(
            r'^(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$',
          );

          if (!passwordRegex.hasMatch(value)) {
            return "Password must have 6 letters,number and special character";
          }
        }

        return null;
      },
    );
  }
}
