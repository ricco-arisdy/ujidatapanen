import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  Future<bool> login(String email, String password) async {
    var url = Uri.parse('http://192.168.100.6/api_pam/login.php');
    var response = await http.post(url, body: {
      'action': 'login',
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return true;
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
}