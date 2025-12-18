import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){
  return ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 20,
          color: Colors.white
        ),
        backgroundColor: Color.fromARGB(255, 56, 36, 13),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
      )
    )
  );
}