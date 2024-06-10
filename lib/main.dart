import 'package:flutter/material.dart';
import 'package:ujidatapanen/screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Tani Jaya',
      home: LoginPage(),
    );
  }
}
