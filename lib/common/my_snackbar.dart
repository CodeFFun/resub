import 'package:flutter/material.dart';

showMySnackBar({
  required BuildContext context,
  required String message,
  Color? color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(fontSize: 12)),
      backgroundColor: color ?? Colors.green,
      duration: Duration(seconds: 2),
      // width: 200,
      behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.only(top: 20, right: 20, left: 200),
    ),
  );
}
