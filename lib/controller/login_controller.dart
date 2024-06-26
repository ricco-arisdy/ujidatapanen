import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ujidatapanen/provider/AuthProvider.dart';
import 'package:ujidatapanen/screen/home.dart';
import 'package:ujidatapanen/service/login_service.dart';

class LoginController {
  final LoginService _loginService = LoginService();

  Future<int?> login(
      BuildContext context, String email, String password) async {
    try {
      print('Logging in with email: $email and password: $password');
      int? userId = await _loginService.login(email, password);
      if (userId != null) {
        print('Login successful, user_id: $userId');
        Provider.of<AuthProvider>(context, listen: false).setUserId(userId);
        return userId;
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
    return null;
  }
}
