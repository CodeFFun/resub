import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/auth/presentation/pages/login_screen.dart';
import 'package:resub/features/profile/presentation/pages/personal_info_page.dart';

class BottomProfileScreen extends ConsumerWidget {
  const BottomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  AppRoutes.push(context, const PersonalInfoPage());
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.brown),
                ),
                child: const Text(
                  "Profile",
                  style: TextStyle(color: Colors.brown),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Clear the userSessionServiceProvider
                  final userSession = ref.read(userSessionServiceProvider);
                  final tokenSession = ref.read(tokenServiceProvider);
                  await userSession.clearSession();
                  await tokenSession.removeToken();

                  ref.invalidate(userSessionServiceProvider);

                  // Navigate to login
                  if (context.mounted) {
                    AppRoutes.pushReplacement(context, const LoginScreen());
                  }
                },
                child: const Text("Logout"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
