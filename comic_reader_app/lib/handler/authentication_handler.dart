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
    final user = users.firstWhere(
        (user) => user.username == username && user.password == password);
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
