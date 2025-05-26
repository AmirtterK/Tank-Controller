import 'package:flutter/material.dart';
import 'package:Williams/services/themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _theme = darkMode;
  ThemeData get themeData => _theme;
  bool get isDarkMode => _theme == darkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _theme = isDarkMode ? darkMode : lightMode;
    notifyListeners();
  }

  set themeData(ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }

  void toggleTheme() async {
    themeData = isDarkMode ? lightMode : darkMode;
  }

  
}
