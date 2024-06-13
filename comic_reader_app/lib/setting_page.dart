import 'package:comic_reader_app/handler/authentication_handler.dart';
import 'package:comic_reader_app/handler/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late ThemeMode _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme =
        Provider.of<ThemeHandler>(context, listen: false).currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    final themeHandler = context.watch<ThemeHandler>();
    final fontSizeHandler = context.watch<FontSizeHandler>();
    final authenticationHandler = context.watch<AuthenticationHandler>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (authenticationHandler.isLoggedIn)
              ListTile(
                title: const Text('Light Theme'),
                trailing: Radio<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: _currentTheme,
                  onChanged: (ThemeMode? value) {
                    setState(
                      () {
                        _currentTheme = value!;
                        themeHandler.toggleTheme(value);
                      },
                    );
                  },
                ),
              ),
            if (authenticationHandler.isLoggedIn)
              ListTile(
                title: const Text('Dark Theme'),
                trailing: Radio(
                  value: ThemeMode.dark,
                  groupValue: _currentTheme,
                  onChanged: (ThemeMode? value) {
                    setState(
                      () {
                        _currentTheme = value!;
                        themeHandler.toggleTheme(value);
                      },
                    );
                  },
                ),
              ),
            if (authenticationHandler.isLoggedIn)
              ListTile(
                title: const Text('Follow System Theme'),
                trailing: Radio(
                  value: ThemeMode.system,
                  groupValue: _currentTheme,
                  onChanged: (ThemeMode? value) {
                    setState(
                      () {
                        _currentTheme = value!;
                        themeHandler.toggleTheme(value);
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Font Size Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: fontSizeHandler.sliderFontSize,
              min: 0.5,
              max: 1.5,
              divisions: 10,
              label: fontSizeHandler.fontSize.toStringAsFixed(1),
              onChanged: (double value) {
                fontSizeHandler.fontSize = value;
              },
            ),
            Text(
              'Current Font Size: ${fontSizeHandler.fontSize.toStringAsFixed(1)}',
              style: TextStyle(fontSize: fontSizeHandler.fontSize),
            ),
          ],
        ),
      ),
    );
  }
}
