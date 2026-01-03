import 'package:flutter/material.dart';

class BottomMyCartScreen extends StatelessWidget {
  const BottomMyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Text(
          'Your Cart is Empty',
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