import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ujidatapanen/model/panen.dart';

class ViewPanenServiceLoading {
  static const String apiUrl =
      'http://192.168.0.192/api_pam/get_panenbyloading.php';

  Future<List<Panen>> fetchPanen(int idLoading) async {
    final response = await http.get(Uri.parse('$apiUrl?id_loading=$idLoading'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Panen.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load panen data');
    }
  }
}
