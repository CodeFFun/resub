import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

final proximitySensorServiceProvider = Provider<ProximitySensorService>((ref) {
  return ProximitySensorService();
});

class ProximitySensorService {
  StreamSubscription<int>? _subscription;
  Timer? _resubscribeTimer;
  Timer? _watchdogTimer;
  Timer? _valueLogTimer;
  DateTime? _lastEventAt;
  int? _lastValue;

  // Callback function to be called when proximity is detected
  Function()? onProximityDetected;

  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;

  // Time in milliseconds that proximity must be detected before triggering
  static const int proximityDelay = 3000; // 3 seconds
  static const int watchdogIntervalMs = 4000;
  static const int staleEventThresholdMs = 9000;
  static const int farWaitTimeoutMs = 30000;
  static const int retriggerCooldownMs = 8000;
  Timer? _proximityTimer;
  bool _isNear = false;
  int _eventCount = 0;
  bool _hasTriggered = false; // Track if we've triggered once
  bool _requiresFarBeforeNextTrigger = false;
  bool _waitingForInitialFar =
      false; // Must see FAR before first NEAR can trigger
  DateTime? _triggerLockStartedAt;
  DateTime? _cooldownUntil;

  /// Start listening to proximity sensor changes
  Future<void> startListening(Function() callback) async {
    if (_isEnabled) {
      return;
    }

    onProximityDetected = callback;
    _isEnabled = true;
    _isNear = false;
    _eventCount = 0;
    _hasTriggered = false;
    _requiresFarBeforeNextTrigger = false;
    _waitingForInitialFar = true; // Require FAR before first trigger
    _triggerLockStartedAt = null;
    _cooldownUntil = null;
    _lastEventAt = DateTime.now();
    _lastValue = null;

    try {
      _bindSensorStream();
      _startWatchdog();
      _startPeriodicValueLog();
    } catch (e) {
      _isEnabled = false;
    }
  }

  void _bindSensorStream() {
    _subscription?.cancel();
    _subscription = ProximitySensor.events.listen(
      (value) {
        _lastValue = value;
        _eventCount++;
        _lastEventAt = DateTime.now();

        if (!_isEnabled) {
          return;
        }

        // value: 0 = NEAR, 1 (or higher) = FAR
        final isNear = value == 0;

        final cooldownUntil = _cooldownUntil;
        if (cooldownUntil != null && DateTime.now().isBefore(cooldownUntil)) {
          if (isNear) {
            return;
          }
        } else if (cooldownUntil != null) {
          _cooldownUntil = null;
        }

        // Require seeing FAR after initialization before allowing any NEAR trigger.
        // This prevents immediate triggers when sensor starts in NEAR state.
        if (_waitingForInitialFar) {
          if (!isNear) {
            _waitingForInitialFar = false;
          } else {
            return;
          }
        }

        // Once triggered, do not allow any new trigger until a FAR event arrives.
        if (_requiresFarBeforeNextTrigger) {
          if (!isNear) {
            _requiresFarBeforeNextTrigger = false;
            _triggerLockStartedAt = null;
            _isNear = false;
            _hasTriggered = false;
            _cancelProximityTimer();
          } else {
            _isNear = true;
            _cancelProximityTimer();
          }
          return;
        }

        if (isNear && !_isNear) {
          // Object came near, start timer
          _isNear = true;
          _startProximityTimer();
        } else if (!isNear && _isNear) {
          // Object moved away, reset state for next trigger
          _isNear = false;
          _hasTriggered = false; // Allow re-triggering
          _cancelProximityTimer();
        }
      },
      onError: (Object error) {
        _subscription = null;
        _scheduleResubscribe('error');
      },
      onDone: () {
        _subscription = null;
        _scheduleResubscribe('done');
      },
      cancelOnError: true,
    );
  }

  void _scheduleResubscribe(String reason) {
    if (!_isEnabled) return;
    if (_resubscribeTimer?.isActive ?? false) return;

    _resubscribeTimer = Timer(const Duration(milliseconds: 400), () {
      if (_isEnabled && _subscription == null) {
        _bindSensorStream();
      }
    });
  }

  void _startWatchdog() {
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer.periodic(
      const Duration(milliseconds: watchdogIntervalMs),
      (_) {
        if (!_isEnabled) return;

        // During post-trigger lock, no new events can be normal on some devices.
        // Avoid aggressive rebind loops until a FAR transition arrives.
        if (_requiresFarBeforeNextTrigger && _lastValue == 0) {
          final lockStarted = _triggerLockStartedAt;
          if (lockStarted != null) {
            final lockAge = DateTime.now()
                .difference(lockStarted)
                .inMilliseconds;
            if (lockAge >= farWaitTimeoutMs) {
              _requiresFarBeforeNextTrigger = false;
              _triggerLockStartedAt = null;
              _isNear = false;
              _hasTriggered = false;
              _cooldownUntil = DateTime.now().add(
                const Duration(milliseconds: retriggerCooldownMs),
              );
              _cancelProximityTimer();
            }
          }
          return;
        }

        final lastEvent = _lastEventAt;
        if (lastEvent == null) return;

        final staleFor = DateTime.now().difference(lastEvent).inMilliseconds;
        if (staleFor >= staleEventThresholdMs) {
          _lastValue = null;
          _subscription?.cancel();
          _subscription = null;
          _scheduleResubscribe('stale');
        }
      },
    );
  }

  void _refreshAfterTrigger() {
    if (!_isEnabled) return;
    _subscription?.cancel();
    _subscription = null;
    _lastEventAt = DateTime.now();
    _scheduleResubscribe('post-trigger');
  }

  void _startPeriodicValueLog() {
    _valueLogTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_isEnabled) return;
      final value = _lastValue;
      if (value == null) {
        return;
      }

      final lastEvent = _lastEventAt;
      final staleMs = lastEvent == null
          ? -1
          : DateTime.now().difference(lastEvent).inMilliseconds;
      if (staleMs >= staleEventThresholdMs) {
        print(
          '🕒 Proximity sensor: Last value is stale (${staleMs}ms old) = $value',
        );
        return;
      }

      final label = value == 0 ? 'NEAR' : 'FAR';
    });
  }

  void _startProximityTimer() {
    _cancelProximityTimer();
    _proximityTimer = Timer(Duration(milliseconds: proximityDelay), () {
      if (_isEnabled && _isNear) {
        _hasTriggered = true; // Mark as triggered
        _requiresFarBeforeNextTrigger = true;
        _triggerLockStartedAt = DateTime.now();
        onProximityDetected?.call();
        // Force a stream refresh because some devices/plugins stop emitting
        // subsequent events until listener is recreated.
        _refreshAfterTrigger();
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
    _resubscribeTimer?.cancel();
    _resubscribeTimer = null;
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    _valueLogTimer?.cancel();
    _valueLogTimer = null;
    _cancelProximityTimer();
    await _subscription?.cancel();
    _subscription = null;
    onProximityDetected = null;
    _isNear = false;
    _hasTriggered = false;
    _requiresFarBeforeNextTrigger = false;
    _triggerLockStartedAt = null;
    _waitingForInitialFar = false;
    _cooldownUntil = null;
    _eventCount = 0;
    _lastEventAt = null;
    _lastValue = null;
  }

  /// Dispose resources
  void dispose() {
    stopListening();
  }
}
