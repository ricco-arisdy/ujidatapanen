import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/loading.dart';

class EditLoadingService {
  Future<bool> updateLoading(Loading loading) async {
    var url = Uri.parse('http://192.168.100.6/api_pam/edit_loading.php');
    var response = await http.post(url, body: {
      'id': loading.id.toString(),
      'nama_loading': loading.namaLoading,
      'pemilik': loading.pemilik,
      'alamat': loading.alamat,
      'lokasi': loading.lokasi,
      'user_id': loading.userId.toString(),
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
