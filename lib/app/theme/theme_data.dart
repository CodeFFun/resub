import 'package:flutter/material.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color secondaryText;
  final Color mutedText;
  final Color hoverAccent;
  final Color deepBrand;
  final Color border;
  final Color cardBackground;

  const AppThemeColors({
    required this.secondaryText,
    required this.mutedText,
    required this.hoverAccent,
    required this.deepBrand,
    required this.border,
    required this.cardBackground,
  });

  @override
  AppThemeColors copyWith({
    Color? secondaryText,
    Color? mutedText,
    Color? hoverAccent,
    Color? deepBrand,
    Color? border,
    Color? cardBackground,
  }) {
    return AppThemeColors(
      secondaryText: secondaryText ?? this.secondaryText,
      mutedText: mutedText ?? this.mutedText,
      hoverAccent: hoverAccent ?? this.hoverAccent,
      deepBrand: deepBrand ?? this.deepBrand,
      border: border ?? this.border,
      cardBackground: cardBackground ?? this.cardBackground,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }

    return AppThemeColors(
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      hoverAccent: Color.lerp(hoverAccent, other.hoverAccent, t)!,
      deepBrand: Color.lerp(deepBrand, other.deepBrand, t)!,
      border: Color.lerp(border, other.border, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
    );
  }
}

class _ThemePalette {
  static const Color lightBackground = Color(0xFFFDFBD4);
  static const Color lightSurface = Color(0xFFFFF8E8);
  static const Color lightCard = Color(0xFFFFFDF0);
  static const Color lightPrimary = Color(0xFFC05800);
  static const Color lightHoverAccent = Color(0xFFD96A0A);
  static const Color lightDeepBrand = Color(0xFF713600);
  static const Color lightTextPrimary = Color(0xFF38240D);
  static const Color lightTextSecondary = Color(0xFF5A3A1A);
  static const Color lightTextMuted = Color(0xFF7A5A36);
  static const Color lightBorder = Color(0xFFE6D9B8);

  static const Color darkBackground = Color(0xFF1A1208);
  static const Color darkSurface = Color(0xFF24170D);
  static const Color darkCard = Color(0xFF2B1C12);
  static const Color darkPrimary = Color(0xFFE07A1F);
  static const Color darkHoverAccent = Color(0xFFF08C2E);
  static const Color darkTextPrimary = Color(0xFFF5EBD8);
  static const Color darkTextSecondary = Color(0xFFD6C2A8);
  static const Color darkTextMuted = Color(0xFFA89278);
  static const Color darkBorder = Color(0xFF3A2A1C);
}

ThemeData getApplicationLightTheme() {
  final colorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: _ThemePalette.lightPrimary,
    onPrimary: Colors.white,
    secondary: _ThemePalette.lightDeepBrand,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: _ThemePalette.lightSurface,
    onSurface: _ThemePalette.lightTextPrimary,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: _ThemePalette.lightBackground,
    canvasColor: _ThemePalette.lightBackground,
    dividerColor: _ThemePalette.lightBorder,
    cardTheme: const CardThemeData(
      color: _ThemePalette.lightCard,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: _ThemePalette.lightBorder),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _ThemePalette.lightSurface,
      surfaceTintColor: Colors.transparent,
      foregroundColor: _ThemePalette.lightTextPrimary,
      elevation: 0,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: _ThemePalette.lightCard,
      labelStyle: TextStyle(color: _ThemePalette.lightTextMuted),
      hintStyle: TextStyle(color: _ThemePalette.lightTextMuted),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: _ThemePalette.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: _ThemePalette.lightPrimary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: Colors.red),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: _ThemePalette.lightTextPrimary),
      bodyMedium: TextStyle(color: _ThemePalette.lightTextSecondary),
      bodySmall: TextStyle(color: _ThemePalette.lightTextMuted),
      titleLarge: TextStyle(color: _ThemePalette.lightTextPrimary),
      titleMedium: TextStyle(color: _ThemePalette.lightTextPrimary),
      titleSmall: TextStyle(color: _ThemePalette.lightTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: _ThemePalette.lightPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppThemeColors(
        secondaryText: _ThemePalette.lightTextSecondary,
        mutedText: _ThemePalette.lightTextMuted,
        hoverAccent: _ThemePalette.lightHoverAccent,
        deepBrand: _ThemePalette.lightDeepBrand,
        border: _ThemePalette.lightBorder,
        cardBackground: _ThemePalette.lightCard,
      ),
    ],
  );
}

ThemeData getApplicationDarkTheme() {
  final colorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: _ThemePalette.darkPrimary,
    onPrimary: Color(0xFF1A1208),
    secondary: _ThemePalette.darkHoverAccent,
    onSecondary: Color(0xFF1A1208),
    error: Colors.redAccent,
    onError: Colors.black,
    surface: _ThemePalette.darkSurface,
    onSurface: _ThemePalette.darkTextPrimary,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: _ThemePalette.darkBackground,
    canvasColor: _ThemePalette.darkBackground,
    dividerColor: _ThemePalette.darkBorder,
    cardTheme: const CardThemeData(
      color: _ThemePalette.darkCard,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: _ThemePalette.darkBorder),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _ThemePalette.darkSurface,
      surfaceTintColor: Colors.transparent,
      foregroundColor: _ThemePalette.darkTextPrimary,
      elevation: 0,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: _ThemePalette.darkCard,
      labelStyle: TextStyle(color: _ThemePalette.darkTextMuted),
      hintStyle: TextStyle(color: _ThemePalette.darkTextMuted),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: _ThemePalette.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: _ThemePalette.darkPrimary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: Colors.redAccent),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: _ThemePalette.darkTextPrimary),
      bodyMedium: TextStyle(color: _ThemePalette.darkTextSecondary),
      bodySmall: TextStyle(color: _ThemePalette.darkTextMuted),
      titleLarge: TextStyle(color: _ThemePalette.darkTextPrimary),
      titleMedium: TextStyle(color: _ThemePalette.darkTextPrimary),
      titleSmall: TextStyle(color: _ThemePalette.darkTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: _ThemePalette.darkPrimary,
        foregroundColor: _ThemePalette.darkBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppThemeColors(
        secondaryText: _ThemePalette.darkTextSecondary,
        mutedText: _ThemePalette.darkTextMuted,
        hoverAccent: _ThemePalette.darkHoverAccent,
        deepBrand: _ThemePalette.darkPrimary,
        border: _ThemePalette.darkBorder,
        cardBackground: _ThemePalette.darkCard,
      ),
    ],
  );
}
