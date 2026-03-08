import 'package:flutter/material.dart';
import 'package:resub/core/utils/responsive_utils.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Color.fromARGB(255, 56, 36, 13),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(context.rSpacing(8)),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: context.rFont(20)),
          ),
        ),
      ),
    );
  }
}
