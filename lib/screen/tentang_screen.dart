import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TentangView extends StatefulWidget {
  const TentangView({Key? key});

  @override
  State<TentangView> createState() => _TentangViewState();
}

class _TentangViewState extends State<TentangView> {
  late String _username = '';
  late String _email = '';

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil data pengguna saat widget diinisialisasi
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Lakukan permintaan HTTP untuk mengambil data pengguna berdasarkan email
      var response = await http.post(
        Uri.parse(
            'http://192.168.100.6/api_pam/get_tentang.php'), // URL API yang dimodifikasi
        body: {
          'email': 'aku@gmail.com'
        }, // Ganti dengan alamat email pengguna yang sesuai
      );

      // Periksa apakah permintaan berhasil
      if (response.statusCode == 200) {
        // Ubah respons JSON menjadi map
        Map<String, dynamic> userData = jsonDecode(response.body);

        // Perbarui state dengan data pengguna yang diterima
        setState(() {
          _username = userData['user_data']['username'];
          _email = userData['user_data']['email'];
        });
      } else {
        // Jika permintaan gagal, tampilkan pesan kesalahan
        print('Gagal mengambil data: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Tangani kesalahan jika terjadi
      print('Terjadi kesalahan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: $_username',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $_email',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
