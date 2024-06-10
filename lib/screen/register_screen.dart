import 'package:flutter/material.dart';
import 'package:ujidatapanen/controller/register_controller.dart';
import 'package:ujidatapanen/model/user.dart';
import 'package:ujidatapanen/screen/home.dart';
import 'package:ujidatapanen/screen/login_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController _registerController = RegisterController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            TextFormField(
              controller: noTelpController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = usernameController.text;
                String alamat = alamatController.text;
                int noTelp = int.tryParse(noTelpController.text) ?? 0;
                String email = emailController.text;
                String password = passwordController.text;
                User user = User(
                  id: 0,
                  username: username,
                  alamat: alamat,
                  no_telp: noTelp,
                  email: email,
                  password: password,
                );
                bool registerSuccess =
                    await _registerController.registerUser(context, user);
                if (registerSuccess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPage()), // Pindah ke home view
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
