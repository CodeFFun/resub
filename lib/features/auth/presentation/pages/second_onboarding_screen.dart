import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/utils/snackbar_utils.dart';
import 'package:resub/features/auth/presentation/pages/login_screen.dart';
import 'package:resub/features/auth/presentation/state/auth_state.dart';
import 'package:resub/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:resub/features/auth/presentation/widgets/role_select.dart';
import 'package:resub/features/user/domain/entities/user_entity.dart';

class SecondOnboardingScreen extends ConsumerStatefulWidget {
  final String email;

  const SecondOnboardingScreen({super.key, required this.email});

  @override
  ConsumerState<SecondOnboardingScreen> createState() =>
      _SecondOnboardingScreenState();
}

class _SecondOnboardingScreenState
    extends ConsumerState<SecondOnboardingScreen> {
  String? selectedRole;

  Future<void> _handleNextPressed() async {
    if (selectedRole == null) {
      SnackbarUtils.showError(context, 'Please select a role to continue');
      return;
    }

    final updateData = UserEntity(
      role: selectedRole == 'Shop Owner' ? 'shop' : 'customer',
    );

    await ref
        .read(authViewModelProvider.notifier)
        .updateUserByEmail(email: widget.email, updateData: updateData);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        SnackbarUtils.showSuccess(context, 'Role created successfully!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'Please select\nYour role',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[900],
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              // Clipboard icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoleSelect(
                    selectedRole: selectedRole,
                    role: "Customer",
                    title: "Customer",
                    icon: Icons.person_outline,
                    onTap: () {
                      setState(() {
                        selectedRole = 'Customer';
                      });
                    },
                  ),
                  RoleSelect(
                    selectedRole: selectedRole,
                    role: "Shop Owner",
                    title: "Shop Owner",
                    icon: Icons.store_mall_directory_outlined,
                    onTap: () {
                      setState(() {
                        selectedRole = 'Shop Owner';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.brown[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.brown[900],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.brown[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
