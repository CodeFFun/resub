import 'dart:async';
import 'package:ambient_light/ambient_light.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ambientLightServiceProvider = Provider<AmbientLightService>((ref) {
  final service = AmbientLightService();
  ref.onDispose(() => service.dispose());
  return service;
});

class AmbientLightService {
  final AmbientLight _ambientLight = AmbientLight();
  StreamSubscription<double>? _subscription;

  // Lux threshold
  static const int darkModeThreshold = 50;

  Function(bool isDark)? onThemeChange;

  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;

  /// Start listening to ambient light
  Future<void> startListening(Function(bool isDark) callback) async {
    if (_isEnabled) return;

    onThemeChange = callback;
    _isEnabled = true;

    try {
      _subscription = _ambientLight.ambientLightStream.listen((luxValue) {
        if (!_isEnabled) return;

        final isDark = luxValue < darkModeThreshold;
        onThemeChange?.call(isDark);
      });

      if (_subscription == null) {
        _isEnabled = false;
      }
    } catch (e) {
      _isEnabled = false;
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    _isEnabled = false;
    await _subscription?.cancel();
    _subscription = null;
    onThemeChange = null;
  }

  /// Dispose
  void dispose() {
    stopListening();
  }
}
