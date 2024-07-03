import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ujidatapanen/controller/AddPanen_Controller.dart';
import 'package:ujidatapanen/model/loading.dart';
import 'package:ujidatapanen/model/panen.dart';
import 'package:ujidatapanen/provider/AuthProvider.dart';
import 'package:ujidatapanen/service/loading/ViewLoading_Service.dart';

class AddPanenScreen extends StatefulWidget {
  final int idLahan;

  const AddPanenScreen({required this.idLahan, Key? key}) : super(key: key);

  @override
  _AddPanenScreenState createState() => _AddPanenScreenState();
}

class _AddPanenScreenState extends State<AddPanenScreen> {
  final PanenController _panenController = PanenController();
  TextEditingController noPanenController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  int selectedLoadingId = 0;
  List<Loading> loadingList = []; // Untuk menyimpan daftar Loading
  DateTime selectedDate = DateTime.now();
  File? imageFile;

  @override
  void initState() {
    super.initState();
    fetchLoadingData();
  }

  void fetchLoadingData() async {
    try {
      int userId =
          Provider.of<AuthProvider>(context, listen: false).userId ?? 0;
      List<Loading> data = await ViewLoadingService().fetchLoading(userId);
      setState(() {
        loadingList = data;
        if (loadingList.isNotEmpty) {
          selectedLoadingId = loadingList[0]
              .id; // Inisialisasi selectedLoadingId dengan nilai pertama jika tersedia
        }
      });
    } catch (e) {
      print('Error fetching loading data: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Panen'),
        backgroundColor: const Color(0xFF1A4D2E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF1A4D2E),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: noPanenController,
                decoration: const InputDecoration(
                  labelText: 'No Panen',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextFormField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextFormField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: _showImageSourceActionSheet,
                child: const Text('Pilih Foto'),
              ),
              if (imageFile != null) Image.file(imageFile!),
              TextFormField(
                controller: deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Pilih Loading',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                value: selectedLoadingId,
                items: loadingList.map((loading) {
                  return DropdownMenuItem<int>(
                    value: loading.id,
                    child: Text(loading.namaLoading),
                  );
                }).toList(),
                onChanged: (int? value) {
                  setState(() {
                    selectedLoadingId = value ?? 0;
                  });
                },
                validator: (value) {
                  if (value == null || value == 0) {
                    return 'Pilih Loading';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String noPanen = noPanenController.text;
                  double jumlah = double.tryParse(jumlahController.text) ?? 0.0;
                  double harga = double.tryParse(hargaController.text) ?? 0.0;
                  String deskripsi = deskripsiController.text;

                  Panen panen = Panen(
                    id: 0,
                    noPanen: noPanen,
                    tanggalPanen: selectedDate,
                    jumlah: jumlah,
                    harga: harga,
                    foto: imageFile != null ? imageFile!.path : '',
                    deskripsi: deskripsi,
                    idLahan: widget.idLahan,
                    idLoading: selectedLoadingId,
                  );

                  bool createSuccess = await _panenController
                      .createPanen(context, panen, imageFile: imageFile);

                  if (createSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Panen berhasil ditambahkan'),
                        duration: Duration(seconds: 5),
                        backgroundColor: Colors.blue,
                      ),
                    );
                    Navigator.pop(
                        context, true); // Kembali ke halaman sebelumnya
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Ubah warna tombol jika perlu
                  textStyle: const TextStyle(fontSize: 16),
                  fixedSize:
                      const Size(200, 50), // Ubah ukuran tombol jika perlu
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
