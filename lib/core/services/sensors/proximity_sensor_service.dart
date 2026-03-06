import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

final proximitySensorServiceProvider = Provider<ProximitySensorService>((ref) {
  return ProximitySensorService();
});

class ProximitySensorService {
  StreamSubscription<int>? _subscription;

  // Callback function to be called when proximity is detected
  Function()? onProximityDetected;

  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;

  // Time in milliseconds that proximity must be detected before triggering
  static const int proximityDelay = 3000; // 3 seconds
  Timer? _proximityTimer;
  bool _isNear = false;

  /// Start listening to proximity sensor changes
  Future<void> startListening(Function() callback) async {
    if (_isEnabled) {
      return;
    }

    onProximityDetected = callback;
    _isEnabled = true;

    try {
      _subscription = ProximitySensor.events.listen((value) {
        if (!_isEnabled) return;

        // value: 0 = near, 1 or higher = far
        final isNear = value == 0;

        if (isNear && !_isNear) {
          // Object came near, start timer
          _isNear = true;
          _startProximityTimer();
        } else if (!isNear && _isNear) {
          // Object moved away, cancel timer
          _isNear = false;
          _cancelProximityTimer();
        }
      });
    } catch (e) {
      _isEnabled = false;
    }
  }

  void _startProximityTimer() {
    _cancelProximityTimer();
    _proximityTimer = Timer(Duration(milliseconds: proximityDelay), () {
      if (_isEnabled && _isNear) {
        onProximityDetected?.call();
      }
    });
  }

  void _cancelProximityTimer() {
    _proximityTimer?.cancel();
    _proximityTimer = null;
  }

  /// Stop listening to proximity sensor changes
  Future<void> stopListening() async {
    _isEnabled = false;
    _cancelProximityTimer();
    await _subscription?.cancel();
    _subscription = null;
    onProximityDetected = null;
    _isNear = false;
  }

  /// Dispose resources
  void dispose() {
    stopListening();
  }
}
