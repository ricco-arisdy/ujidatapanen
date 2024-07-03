import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteLoadingService {
  Future<bool> deleteLoading(int id) async {
    var url = Uri.parse('http://192.168.0.192/api_pam/delete_loading.php');
    try {
      var response = await http.post(
        url,
        body: {
          'id': id.toString(),
        },
      );

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
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}