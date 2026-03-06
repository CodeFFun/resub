import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/sensors/proximity_sensor_service.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/auth/presentation/pages/login_screen.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _proximityLogoutEnabledKey = 'proximity_logout_enabled';

/// Provider to track if proximity logout is enabled
final proximityLogoutEnabledProvider =
    NotifierProvider<ProximityLogoutNotifier, bool>(
      ProximityLogoutNotifier.new,
    );

class ProximityLogoutNotifier extends Notifier<bool> {
  late final SharedPreferences _preferences;

  @override
  bool build() {
    _preferences = ref.read(sharedPreferencesProvider);
    return _preferences.getBool(_proximityLogoutEnabledKey) ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _preferences.setBool(_proximityLogoutEnabledKey, enabled);
  }
}

/// Widget that wraps the app and provides proximity-based logout functionality
class ProximityLogoutWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const ProximityLogoutWrapper({super.key, required this.child});

  @override
  ConsumerState<ProximityLogoutWrapper> createState() =>
      _ProximityLogoutWrapperState();
}

class _ProximityLogoutWrapperState
    extends ConsumerState<ProximityLogoutWrapper> {
  late final ProximitySensorService _proximitySensorService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _proximitySensorService = ref.read(proximitySensorServiceProvider);
    _initProximitySensor();
  }

  void _initProximitySensor() async {
    // Wait a bit to ensure providers are initialized
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final isEnabled = ref.read(proximityLogoutEnabledProvider);
    if (isEnabled) {
      _startProximityListener();
    }

    setState(() {
      _isInitialized = true;
    });
  }

  void _startProximityListener() {
    _proximitySensorService.startListening(() {
      _handleProximityLogout();
    });
  }

  Future<void> _handleProximityLogout() async {
    if (!mounted) return;

    // Show a dialog to confirm logout or cancel it
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Proximity Logout'),
        content: const Text(
          'Proximity sensor detected. Do you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await _performLogout();
    }
  }

  Future<void> _performLogout() async {
    final userSession = ref.read(userSessionServiceProvider);
    final tokenSession = ref.read(tokenServiceProvider);

    await userSession.clearSession();
    await tokenSession.removeToken();

    ref.invalidate(userSessionServiceProvider);

    if (mounted) {
      AppRoutes.pushReplacement(context, const LoginScreen());
    }
  }

  @override
  void dispose() {
    _proximitySensorService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes in proximity logout enabled setting
    ref.listen<bool>(proximityLogoutEnabledProvider, (previous, next) {
      if (_isInitialized) {
        if (next) {
          _startProximityListener();
        } else {
          _proximitySensorService.stopListening();
        }
      }
    });

    return widget.child;
  }
}
