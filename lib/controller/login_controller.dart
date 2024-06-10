import 'package:flutter/material.dart';
import 'package:ujidatapanen/screen/home.dart';
import 'package:ujidatapanen/service/login_service.dart';

class LoginController {
  final LoginService _loginService = LoginService();

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      bool loginSuccess = await _loginService.login(email, password);
      if (loginSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }
}