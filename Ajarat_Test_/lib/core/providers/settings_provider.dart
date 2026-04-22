import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  // Default Settings
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  // 1. Load Settings on App Start
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Theme
    final themeString = prefs.getString('theme_mode');
    if (themeString == 'dark') _themeMode = ThemeMode.dark;
    else if (themeString == 'light') _themeMode = ThemeMode.light;
    else _themeMode = ThemeMode.system;

    // Load Language
    final langString = prefs.getString('language_code');
    if (langString != null) {
      _locale = Locale(langString);
    }
    
    notifyListeners();
  }

  // 2. Toggle Theme
  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', isDark ? 'dark' : 'light');
  }

  // 3. Toggle Language
  Future<void> toggleLanguage(bool isArabic) async {
    _locale = isArabic ? const Locale('ar') : const Locale('en');
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', isArabic ? 'ar' : 'en');
  }
}