import 'package:flutter/material.dart';

class BottomHomeScreen extends StatelessWidget {
  const BottomHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Text(
          'Welcome to Homepage',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
