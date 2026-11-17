import 'dart:developer';

import 'package:comic_reader_app/mock_data/data.dart';
import 'package:comic_reader_app/model/user.dart';
import 'package:flutter/material.dart';

class AuthenticationHandler extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  void login(String username, String password) {
    log(username);
    log(password);
    final userIndex = users.indexWhere(
        (user) => user.username == username && user.password == password);
    if (userIndex == -1) {
      throw Exception('Invalid username or password.');
    }
    _user = users[userIndex];
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
