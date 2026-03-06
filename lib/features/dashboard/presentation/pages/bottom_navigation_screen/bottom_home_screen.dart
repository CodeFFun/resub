import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/graph/presentation/pages/shop_overview_screen.dart';
import 'package:resub/features/home/presentation/pages/home_page_screen.dart';

class BottomHomeScreen extends ConsumerStatefulWidget {
  const BottomHomeScreen({super.key});

  @override
  ConsumerState<BottomHomeScreen> createState() => _BottomHomeScreenState();
}

class _BottomHomeScreenState extends ConsumerState<BottomHomeScreen> {
  String checkRole() {
    final userSession = ref.read(userSessionServiceProvider);
    final role = userSession.getCurrentUSerRole();
    return role ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return checkRole() == 'customer' ? HomePageScreen() : ShopOverviewScreen();
  }
}
