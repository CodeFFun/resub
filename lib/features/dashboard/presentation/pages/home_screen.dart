import 'package:flutter/material.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/features/dashboard/presentation/pages/bottom_navigation_screen/bottom_home_screen.dart';
import 'package:resub/features/dashboard/presentation/pages/bottom_navigation_screen/bottom_my_cart_screen.dart';
import 'package:resub/features/dashboard/presentation/pages/bottom_navigation_screen/bottom_order_screen.dart';
import 'package:resub/features/dashboard/presentation/pages/bottom_navigation_screen/bottom_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> lstBottomScreen = [
    const BottomHomeScreen(),
    const BottomMyCartScreen(),
    const BottomOrderScreen(),
    const BottomProfileScreen(),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: appColors?.deepBrand ?? colorScheme.primary,
        unselectedItemColor:
            appColors?.mutedText ??
            colorScheme.onSurface.withValues(alpha: 0.7),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
