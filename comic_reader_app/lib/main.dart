import 'package:comic_reader_app/handler/authentication_handler.dart';
import 'package:comic_reader_app/handler/bookmark_handler.dart';
import 'package:comic_reader_app/handler/comment_handler.dart';
import 'package:comic_reader_app/handler/favorite_handler.dart';
import 'package:comic_reader_app/handler/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ThemeHandler(),
        ),
        ChangeNotifierProvider.value(
          value: BookmarkHandler(),
        ),
        ChangeNotifierProvider.value(
          value: FavoriteHandler(),
        ),
        ChangeNotifierProvider.value(
          value: CommentHandler(),
        ),
        ChangeNotifierProvider.value(
          value: FontSizeHandler(),
        ),
        ChangeNotifierProvider.value(
          value: AuthenticationHandler(),
        )
      ],
      child: Consumer<ThemeHandler>(
        builder: (context, themeHandler, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Comic & Novel App',
            theme: themeHandler.lightTheme,
            darkTheme: themeHandler.darkTheme,
            themeMode: themeHandler.currentTheme,
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
