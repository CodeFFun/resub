import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/settings/presentation/pages/customer_page_screen.dart';
import 'package:resub/features/settings/presentation/pages/profile_page_screen.dart';

class BottomProfileScreen extends ConsumerWidget {
  const BottomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String checkRole() {
      final userSession = ref.read(userSessionServiceProvider);
      final role = userSession.getCurrentUSerRole();
      return role ?? '';
    }

    return checkRole() == 'customer'
        ? const CustomerPageScreen()
        : const ProfilePageScreen();
  }
}
