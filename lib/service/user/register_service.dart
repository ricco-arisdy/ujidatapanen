import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/user.dart';

class AuthService {
  Future<bool> registerUser(User user) async {
    var url = Uri.parse('http://192.168.0.192/api_pam/register.php');
    var response = await http.post(url, body: {
      'id': user.id.toString(),
      'username': user.username,
      'alamat': user.alamat,
      'no_telp': user.no_telp.toString(),
      'email': user.email,
      'password': user.password,
      'tanggal_bergabung': user.tanggalBergabung ?? '',
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return true;
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Gagal terhubung ke server');
    }
  }
}
