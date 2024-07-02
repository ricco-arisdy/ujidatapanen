import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ujidatapanen/controller/AddLoadingController.dart';
import 'package:ujidatapanen/model/loading.dart';
import 'package:ujidatapanen/provider/AuthProvider.dart';
import 'package:ujidatapanen/screen/map_screen.dart';

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
  String? _lokasi;

  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<AuthProvider>(context, listen: false).userId ?? 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A4D2E),
        title: Text(
          'Tambah Loading',
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
              controller: namaLoadingController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nama Loading',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextFormField(
              controller: pemilikController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Pemilik',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextFormField(
              controller: alamatController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Alamat',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _lokasi ?? 'Lokasi belum dipilih',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.map, color: Colors.white),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          onLocationSelected: (selectedLocation) {
                            setState(() {
                              _lokasi = selectedLocation;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String namaLoading = namaLoadingController.text;
                String pemilik = pemilikController.text;
                String alamat = alamatController.text;
                String lokasi = _lokasi ?? '';

                if (lokasi.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lokasi harus dipilih'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

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
