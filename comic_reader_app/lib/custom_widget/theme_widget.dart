import 'package:comic_reader_app/handler/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeWidget extends StatefulWidget {
  final Widget child;

  const ThemeWidget({super.key, required this.child});

  @override
  State<ThemeWidget> createState() => _ThemeWidgetState();
}

class _ThemeWidgetState extends State<ThemeWidget> {
  ThemeHandler theme = ThemeHandler();

  @override
  void initState() {
    super.initState();
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final currentThemeMode = theme.currentTheme;
    final newThemeMode =
        currentThemeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    theme.toggleTheme(newThemeMode);
    await prefs.setInt('theme_mode', newThemeMode.index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => theme,
      child: Consumer<ThemeHandler>(
        builder: (context, themeHandler, child) {
          return MaterialApp(
            title: 'Comic Reader App',
            theme: themeHandler.lightTheme,
            darkTheme: themeHandler.darkTheme,
            themeMode: themeHandler.currentTheme,
            home: widget.child,
          );
        },
      ),
    );
  }
}
