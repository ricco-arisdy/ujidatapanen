import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ujidatapanen/model/loading.dart';

class ViewLoadingService {
  static const String apiUrl = 'http://192.168.100.6/api_pam/get_loading.php';

  Future<List<Loading>> fetchLoading(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl?user_id=$userId'));

    if (response.statusCode == 200) {
      // Ubah respons JSON menjadi List<Loading>
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Loading> loadingList =
          jsonList.map((json) => Loading.fromJson(json)).toList();
      return loadingList;
    } else {
      throw Exception('Failed to load loading data');
    }
  }
}
