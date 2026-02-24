import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/features/settings/presentation/pages/profile_page_screen.dart';

class BottomProfileScreen extends ConsumerWidget {
  const BottomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfilePageScreen();
  }
}
