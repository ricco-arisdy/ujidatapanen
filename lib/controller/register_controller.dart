import 'package:flutter/material.dart';
import 'package:ujidatapanen/model/user.dart';
import 'package:ujidatapanen/service/register_service.dart';

class RegisterController {
  final AuthService _authService = AuthService();

  Future<bool> registerUser(BuildContext context, User user) async {
    try {
      bool registerSuccess = await _authService.registerUser(user);
      if (registerSuccess) {
        Navigator.pop(context);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }
}
