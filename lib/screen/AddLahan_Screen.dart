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
        title: const Text('Tambah Lahan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: namaLahanController,
              decoration: const InputDecoration(labelText: 'Nama Lahan'),
            ),
            TextFormField(
              controller: lokasiController,
              decoration: const InputDecoration(labelText: 'Lokasi'),
            ),
            TextFormField(
              controller: luasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Luas'),
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
              child: const Text('Tambah Lahan'),
            ),
          ],
        ),
      ),
    );
  }
}
