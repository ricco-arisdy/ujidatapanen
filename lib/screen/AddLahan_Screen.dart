import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ujidatapanen/controller/Lahan_Controller.dart';
import 'package:ujidatapanen/model/lahan.dart';
import 'package:ujidatapanen/provider/AuthProvider.dart';

class LahanScreen extends StatefulWidget {
  const LahanScreen({Key? key}) : super(key: key);

  @override
  _LahanScreenState createState() => _LahanScreenState();
}

class _LahanScreenState extends State<LahanScreen> {
  final LahanController _lahanController = LahanController();
  TextEditingController namaLahanController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();
  TextEditingController luasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tambahkan kode inisialisasi lainnya di sini jika diperlukan
  }

  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<AuthProvider>(context, listen: false).userId ?? 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A4D2E),
        title: Text(
          'Tambah Lahan',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Navigasi kembali normal
          },
        ),
      ),
      backgroundColor: Color(0xFF1A4D2E),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: namaLahanController,
              decoration: InputDecoration(
                labelText: 'Nama Lahan',
                labelStyle: TextStyle(
                    color: Colors.white), // Atur warna label teks di sini
              ),
            ),
            TextFormField(
              controller: lokasiController,
              decoration: InputDecoration(
                labelText: 'Lokasi',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextFormField(
              controller: luasController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Luas',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String namaLahan = namaLahanController.text;
                String lokasi = lokasiController.text;
                int luas = int.tryParse(luasController.text) ?? 0;
                Lahan lahan = Lahan(
                  id: 0, // id akan di-generate oleh database (auto increment)
                  namaLahan: namaLahan,
                  lokasi: lokasi,
                  luas: luas,
                  userId: userId, // Menggunakan userId dari Provider
                );
                bool createSuccess =
                    await _lahanController.createLahan(context, lahan);
                if (createSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lahan berhasil ditambahkan'),
                      duration: Duration(seconds: 5),
                      backgroundColor: Colors.blue,
                    ),
                  );
                  Navigator.pop(context, true); // Kembali ke halaman HomeView
                }
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(250, 50)),
              ),
              child: Text('Tambah Lahan', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
