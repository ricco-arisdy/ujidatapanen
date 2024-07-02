import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../model/panen.dart';

class PanenService {
  final String baseUrl = 'http://192.168.0.197/api_pam/';
  final String endpoint = 'add_panen.php';

  Uri getUri(String path) {
    return Uri.parse("$baseUrl$path");
  }

  Future<bool> createPanen(Panen panen, File? imageFile) async {
    try {
      var request = http.MultipartRequest('POST', getUri(endpoint));
      request.fields.addAll({
        'no_panen': panen.noPanen,
        'tanggal_panen': panen.tanggalPanen.toIso8601String(),
        'jumlah': panen.jumlah.toString(),
        'harga': panen.harga.toString(),
        'deskripsi': panen.deskripsi,
        'id_lahan': panen.idLahan.toString(),
        'id_loading': panen.idLoading.toString(),
      });

      if (imageFile != null) {
        var fileName = basename(imageFile.path);
        var file = await http.MultipartFile.fromPath('foto', imageFile.path,
            filename: fileName);
        request.files.add(file);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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
