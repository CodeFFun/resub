import 'package:flutter/material.dart';
import 'package:resub/features/auth/presentation/pages/splash_screen.dart';
import 'package:resub/app/theme/theme_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ReSub",
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: SplashScreen(),
    );
  }
}
