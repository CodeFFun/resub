import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themeModePreferenceKey = 'app_theme_mode_is_dark';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  late final SharedPreferences _preferences;

  @override
  ThemeMode build() {
    _preferences = ref.read(sharedPreferencesProvider);
    final isDarkMode = _preferences.getBool(_themeModePreferenceKey) ?? false;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

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
}
