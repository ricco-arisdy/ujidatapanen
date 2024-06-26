import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewLoadingService {
  static const String apiUrl = 'http://192.168.0.188/api_pam/get_loading.php';

  Future<List<dynamic>> fetchLoading(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl?user_id=$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load loading data');
    }
  }
}
