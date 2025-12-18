import 'package:flutter/material.dart';
import 'package:resub/screen/third_onboarding_screen.dart';
import 'package:resub/widgets/role_select.dart';

class SecondOnboardingScreen extends StatefulWidget {
  const SecondOnboardingScreen({super.key});

  @override
  State<SecondOnboardingScreen> createState() => _SecondOnboardingScreenState();
}

class _SecondOnboardingScreenState extends State<SecondOnboardingScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThirdOnboardingScreen(),
                      ),
                    );
                  },
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
