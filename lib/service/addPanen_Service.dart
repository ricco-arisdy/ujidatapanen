import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/panen.dart';

class PanenService {
  Future<bool> createPanen(Panen panen) async {
    var url = Uri.parse('http://192.168.100.160/api_pam/add_panen.php');
    var response = await http.post(url, body: {
      'no_panen': panen.noPanen,
      'tanggal_panen': panen.tanggalPanen.toIso8601String(),
      'jumlah': panen.jumlah.toString(),
      'harga': panen.harga.toString(),
      'foto': panen.foto,
      'deskripsi': panen.deskripsi,
      'id_lahan': panen.idLahan.toString(),
      'id_loading': panen.idLoading.toString(),
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
