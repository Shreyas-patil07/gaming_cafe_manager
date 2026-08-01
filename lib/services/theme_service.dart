import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {

  static final ValueNotifier<ThemeMode>
  themeNotifier =
  ValueNotifier(
    ThemeMode.light,
  );

  static Future<void> loadTheme() async {
    final prefs =
    await SharedPreferences.getInstance();

    final theme =
    prefs.getString('theme');

    switch (theme) {
      case 'dark':
        themeNotifier.value =
            ThemeMode.dark;
        break;

      case 'light':
        themeNotifier.value =
            ThemeMode.light;
        break;

      default:
        themeNotifier.value =
            ThemeMode.system;
    }
  }

  static Future<void> setTheme(
      ThemeMode mode,
      ) async {
    themeNotifier.value = mode;

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      'theme',
      mode.name,
    );
  }
}