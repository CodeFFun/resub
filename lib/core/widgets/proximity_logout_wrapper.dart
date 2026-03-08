import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/sensors/proximity_sensor_service.dart';
import 'package:resub/core/services/storage/token_service.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:resub/features/auth/presentation/pages/login_screen.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/app/my_app.dart';
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

    if (!mounted) {
      return;
    }

    // Set initialized FIRST before checking enabled state
    setState(() {
      _isInitialized = true;
    });

    // Now check if proximity should be enabled (after _isInitialized is set)
    final isEnabled = ref.read(proximityLogoutEnabledProvider);
    if (isEnabled) {
      _startProximityListener();
    }
  }

  void _startProximityListener() {
    // Always stop first to ensure clean state
    _proximitySensorService.stopListening().then((_) {
      if (mounted) {
        _proximitySensorService.startListening(() {
          _handleProximityLogout();
        });
      }
    });
  }

  Future<void> _handleProximityLogout() async {
    // Get the navigator context from the global key
    final navigatorContext = navigatorKey.currentContext;

    if (navigatorContext == null) {
      return;
    }

    try {
      // Show a dialog to confirm logout or cancel it
      final shouldLogout = await showDialog<bool>(
        context: navigatorContext,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Proximity Logout'),
          content: const Text(
            'Proximity sensor detected. Do you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Logout'),
            ),
          ],
        ),
      );

      if (!mounted) return;

      if (shouldLogout == true) {
        await _performLogout();
      } else {
        ///
      }
    } catch (e) {
      // Handle any errors (e.g., if context is invalid)
    }
  }

  // void _restartProximityListener() {
  //   // Removed - no longer needed
  // }

  Future<void> _performLogout() async {
    final userSession = ref.read(userSessionServiceProvider);
    final tokenSession = ref.read(tokenServiceProvider);

    await userSession.clearSession();
    await tokenSession.removeToken();

    ref.invalidate(userSessionServiceProvider);

    // Use the global navigator key for navigation
    final navigatorContext = navigatorKey.currentContext;
    if (navigatorContext != null && mounted) {
      AppRoutes.pushReplacement(navigatorContext, const LoginScreen());
    }
  }

  @override
  void dispose() {
    // Only stop if the sensor is actually running
    if (_proximitySensorService.isEnabled) {
      _proximitySensorService.stopListening();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes in proximity logout enabled setting
    // This will respond to changes from the settings screen
    ref.listen<bool>(proximityLogoutEnabledProvider, (previous, next) {
      // Only respond to changes after initialization to avoid double-start
      if (_isInitialized && previous != null) {
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
