import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/lahan.dart';

class EditLahanService {
  Future<bool> updateLahan(Lahan lahan) async {
    var url = Uri.parse('http://192.168.0.192/api_pam/edit_lahan.php');
    try {
      var response = await http.post(url, body: {
        'id': lahan.id.toString(),
        'nama_lahan': lahan.namaLahan,
        'lokasi': lahan.lokasi,
        'luas': lahan.luas.toString(),
        'user_id': lahan.userId.toString(),
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
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
