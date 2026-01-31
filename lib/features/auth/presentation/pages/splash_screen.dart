import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/auth/presentation/pages/login_screen.dart';
import 'package:resub/features/dashboard/presentation/pages/home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        _redirect();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _redirect() {
    if (!mounted) return;

    final session = ref.read(userSessionServiceProvider);
    final hasUser =
        (session.getCurrentUserId()?.isNotEmpty ?? false) &&
        (session.getCurrentUserEmail()?.isNotEmpty ?? false);

    if (hasUser) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(child: Image.asset("assets/images/splash.png")),
      ),
    );
  }
}
