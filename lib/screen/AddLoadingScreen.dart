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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(_lokasi ?? 'Lokasi belum dipilih'),
                ),
                IconButton(
                  icon: Icon(Icons.map),
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
            const SizedBox(height: 20),
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
