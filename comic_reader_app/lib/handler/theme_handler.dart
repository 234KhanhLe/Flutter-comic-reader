import 'package:flutter/material.dart';

class ThemeHandler extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeData get lightTheme {
    return ThemeData(brightness: Brightness.light, primaryColor: Colors.white);
  }

  ThemeData get darkTheme {
    return ThemeData(brightness: Brightness.dark, primaryColor: Colors.black);
  }

  ThemeMode get currentTheme => _themeMode;

  void toggleTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

class FontSizeHandler extends ChangeNotifier {
  double _fontSize = 0.5;

  set fontSize(newValue) {
    _fontSize = newValue;
    notifyListeners();
  }

  double get fontSize => _fontSize * 30;

  double get sliderFontSize => _fontSize;
}
