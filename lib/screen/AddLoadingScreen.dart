import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ujidatapanen/controller/AddLoadingController.dart';
import 'package:ujidatapanen/model/loading.dart';
import 'package:ujidatapanen/provider/AuthProvider.dart';
import 'package:ujidatapanen/screen/home.dart';

class AddLoadingScreen extends StatefulWidget {
  const AddLoadingScreen({Key? key}) : super(key: key);

  @override
  _AddLoadingScreenState createState() => _AddLoadingScreenState();
}

class _AddLoadingScreenState extends State<AddLoadingScreen> {
  final LoadingController _loadingController = LoadingController();
  TextEditingController namaLoadingController = TextEditingController();
  TextEditingController pemilikController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<AuthProvider>(context, listen: false).userId ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Loading'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: namaLoadingController,
              decoration: const InputDecoration(labelText: 'Nama Loading'),
            ),
            TextFormField(
              controller: pemilikController,
              decoration: const InputDecoration(labelText: 'Pemilik'),
            ),
            TextFormField(
              controller: alamatController,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            TextFormField(
              controller: lokasiController,
              decoration: const InputDecoration(labelText: 'Lokasi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String namaLoading = namaLoadingController.text;
                String pemilik = pemilikController.text;
                String alamat = alamatController.text;
                String lokasi = lokasiController.text;
                Loading loading = Loading(
                  id: 0, // id akan di-generate oleh database (auto increment)
                  namaLoading: namaLoading,
                  pemilik: pemilik,
                  alamat: alamat,
                  lokasi: lokasi,
                  userId: userId,
                );
                bool createSuccess =
                    await _loadingController.createLoading(context, loading);
                if (createSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Loading berhasil ditambahkan'),
                      duration: Duration(seconds: 5),
                      backgroundColor: Colors.blue,
                    ),
                  );
                  Navigator.pop(context,
                      true); // Kembali ke ViewLoadingScreen dengan nilai true
                }
              },
              child: const Text('Tambah Loading'),
            ),
          ],
        ),
      ),
    );
  }
}
