import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/auth/presentation/pages/login_screen.dart';

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
              child: ElevatedButton(
                onPressed: () async {
                  // Clear the userSessionServiceProvider
                  final userSession = ref.read(userSessionServiceProvider);
                  await userSession.clearSession();

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
