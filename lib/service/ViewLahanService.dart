import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ujidatapanen/model/lahan.dart'; // Sesuaikan dengan lokasi dan nama model Lahan Anda

class ViewLahanService {
  static const String apiUrl = 'http://192.168.0.192/api_pam/get_lahan.php';

  Future<List<Lahan>> fetchLahan(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl?user_id=$userId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonLahanList = jsonDecode(response.body);
      List<Lahan> lahanList = jsonLahanList.map((json) => Lahan.fromJson(json)).toList();
      return lahanList;
    } else {
      throw Exception('Failed to load lahan');
    }
  }
}
