// AuthProvider.dart
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  int? _userId;

  int? get userId => _userId;

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  void clearUser() {
    _userId = null;
    notifyListeners();
  }
}
