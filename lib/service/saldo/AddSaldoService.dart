import 'dart:convert';
import 'package:http/http.dart' as http;

class AddSaldoService {
  Future<bool> addSaldo(int idLoading, int idUser) async {
    var url = Uri.parse('http://192.168.0.192/api_pam/saldo.php');
    var response = await http.post(url, body: {
      'id_loading': idLoading.toString(),
      'id_user': idUser.toString(),
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
