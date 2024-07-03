import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewSaldoService {
  static const String baseUrl = "http://192.168.0.192/api_pam/get_saldo.php";

  Future<Map<String, dynamic>> getSaldo(int idUser) async {
    try {
      var url = Uri.parse('$baseUrl?id_user=$idUser');
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Gagal mengambil saldo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}