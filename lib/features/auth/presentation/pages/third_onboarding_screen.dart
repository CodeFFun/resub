import 'package:flutter/material.dart';
import 'package:resub/core/utils/responsive_utils.dart';
// import 'package:resub/screen/home_screen.dart';
import 'package:resub/features/profile/presentation/pages/personal_info_page.dart';

class ThirdOnboardingScreen extends StatelessWidget {
  const ThirdOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: PersonalInfoPage()),
            Builder(
              builder: (context) => Padding(
                padding: EdgeInsets.all(context.rSpacing(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    SizedBox(width: context.rWidth(8)),
                    Container(
                      width: context.rWidth(60),
                      height: context.rHeight(4),
                      decoration: BoxDecoration(
                        color: Colors.brown[900],
                        borderRadius: BorderRadius.circular(context.rRadius(2)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
