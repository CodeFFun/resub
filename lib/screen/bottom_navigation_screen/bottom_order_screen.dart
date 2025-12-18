import 'package:flutter/material.dart';

class BottomOrderScreen extends StatelessWidget {
  const BottomOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Text(
          'Your Orders',
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