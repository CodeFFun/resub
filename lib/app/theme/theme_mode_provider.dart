import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resub/core/services/sensors/ambient_light_service.dart';

const String _themeModePreferenceKey = 'app_theme_mode_is_dark';
const String _autoThemePreferenceKey = 'app_auto_theme_enabled';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  late final SharedPreferences _preferences;
  late final AmbientLightService _ambientLightService;
  bool _isAutoThemeEnabled = false;

  @override
  ThemeMode build() {
    _preferences = ref.read(sharedPreferencesProvider);
    _ambientLightService = ref.read(ambientLightServiceProvider);
    _isAutoThemeEnabled =
        _preferences.getBool(_autoThemePreferenceKey) ?? false;

    final isDarkMode = _preferences.getBool(_themeModePreferenceKey) ?? false;

    // Start ambient light listener if auto theme is enabled
    if (_isAutoThemeEnabled) {
      _startAmbientLightListener();
    }

    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isAutoThemeEnabled => _isAutoThemeEnabled;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) {
      return;
    }

    state = mode;
    await _preferences.setBool(_themeModePreferenceKey, mode == ThemeMode.dark);
  }

  Future<void> toggleTheme(bool isDarkMode) async {
    await setThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  /// Enable or disable automatic theme switching based on ambient light
  Future<void> setAutoThemeEnabled(bool enabled) async {
    _isAutoThemeEnabled = enabled;
    await _preferences.setBool(_autoThemePreferenceKey, enabled);

    if (enabled) {
      _startAmbientLightListener();
    } else {
      await _ambientLightService.stopListening();
    }
  }

  void _startAmbientLightListener() {
    _ambientLightService.startListening((isDark) {
      // Update theme based on ambient light without saving to preferences
      // This allows auto theme to work without overwriting user preference
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }
}
