import 'package:comic_reader_app/handler/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeHandler = context.watch<ThemeHandler>();
    final fontSizeHandler = context.watch<FontSizeHandler>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RadioGroup<ThemeMode>(
              groupValue: themeHandler.currentTheme,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeHandler.toggleTheme(value);
                }
              },
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Light Theme'),
                    trailing: const Radio<ThemeMode>(
                      value: ThemeMode.light,
                    ),
                    onTap: () => themeHandler.toggleTheme(ThemeMode.light),
                  ),
                  ListTile(
                    title: const Text('Dark Theme'),
                    trailing: const Radio<ThemeMode>(
                      value: ThemeMode.dark,
                    ),
                    onTap: () => themeHandler.toggleTheme(ThemeMode.dark),
                  ),
                  ListTile(
                    title: const Text('Follow System Theme'),
                    trailing: const Radio<ThemeMode>(
                      value: ThemeMode.system,
                    ),
                    onTap: () => themeHandler.toggleTheme(ThemeMode.system),
                  ),
                ],
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
