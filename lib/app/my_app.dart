import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/theme/theme_mode_provider.dart';
import 'package:resub/features/auth/presentation/pages/splash_screen.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/core/widgets/proximity_logout_wrapper.dart';

// Global navigator key for accessing navigator from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: "ReSub",
      debugShowCheckedModeBanner: false,
      theme: getApplicationLightTheme(),
      darkTheme: getApplicationDarkTheme(),
      themeMode: themeMode,
      builder: (context, child) {
        return ProximityLogoutWrapper(child: child ?? const SizedBox());
      },
      home: SplashScreen(),
    );
  }
}
