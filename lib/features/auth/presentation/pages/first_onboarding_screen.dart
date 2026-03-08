import 'package:flutter/material.dart';
import 'package:resub/core/utils/responsive_utils.dart';
import 'package:resub/features/auth/presentation/pages/second_onboarding_screen.dart';

class FirstOnboardingScreen extends StatelessWidget {
  final String? email;

  const FirstOnboardingScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.rSpacing(32)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'Welcome\nOnboard!',
                style: TextStyle(
                  fontSize: context.rFont(48),
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[900],
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.rHeight(60)),
              // Light bulb icon
              Icon(
                Icons.lightbulb_outline,
                size: context.rIcon(120),
                color: Colors.brown[800],
              ),
              SizedBox(height: context.rHeight(60)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: context.rHeight(56),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SecondOnboardingScreen(email: email ?? ''),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.rRadius(28)),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: context.rFont(18),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.rHeight(40)),
              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: context.rWidth(60),
                    height: context.rHeight(4),
                    decoration: BoxDecoration(
                      color: Colors.brown[900],
                      borderRadius: BorderRadius.circular(context.rRadius(2)),
                    ),
                  ),
                  SizedBox(width: context.rWidth(8)),
                  Container(
                    width: context.rWidth(8),
                    height: context.rHeight(4),
                    decoration: BoxDecoration(
                      color: Colors.brown[300],
                      borderRadius: BorderRadius.circular(context.rRadius(2)),
                    ),
                  ),
                  SizedBox(width: context.rWidth(8)),
                  Container(
                    width: context.rWidth(8),
                    height: context.rHeight(4),
                    decoration: BoxDecoration(
                      color: Colors.brown[300],
                      borderRadius: BorderRadius.circular(context.rRadius(2)),
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
