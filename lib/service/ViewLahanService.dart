import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewLahanService {
  static const String apiUrl = 'http://192.168.0.188/api_pam/get_lahan.php';

  Future<List<dynamic>> fetchLahan(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl?user_id=$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load lahan');
    }
  }
}
