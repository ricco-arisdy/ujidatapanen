import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  Future<bool> login(String email, String password) async {
    var url = Uri.parse('http://192.168.0.139/api_pam/login.php');
    var response = await http.post(url, body: {
      'action': 'login',
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Response from server: $jsonResponse');
      if (jsonResponse['status'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? username = jsonResponse['username'];
        print('Username from response: $username');
        prefs.setString('username', username ?? '');
        prefs.setString('email', email);

        print('Data login berhasil disimpan ke dalam SharedPreferences');

        return true;
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
}
