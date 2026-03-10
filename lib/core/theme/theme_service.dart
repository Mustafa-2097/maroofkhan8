import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final String _key = 'isDarkMode';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool _loadThemeFromPrefs() {
    return _prefs?.getBool(_key) ?? false;
  }

  ThemeMode get theme =>
      _loadThemeFromPrefs() ? ThemeMode.dark : ThemeMode.light;

  void _saveThemeToPrefs(bool isDarkMode) {
    _prefs?.setBool(_key, isDarkMode);
  }

  void switchTheme(bool value) {
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToPrefs(value);
  }

  bool isDarkMode() => _loadThemeFromPrefs();
}
