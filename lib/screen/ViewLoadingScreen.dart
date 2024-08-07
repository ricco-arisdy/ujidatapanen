import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ujidatapanen/controller/EditLoading_Controller.dart';
import 'package:ujidatapanen/model/loading.dart';
import 'package:ujidatapanen/provider/AuthProvider.dart';
import 'package:ujidatapanen/screen/ViewLoadingDetail.dart';
import 'package:ujidatapanen/screen/login_screen.dart';
import 'package:ujidatapanen/screen/map_screen.dart';
import 'package:ujidatapanen/screen/tentang_screen.dart';
import 'package:ujidatapanen/service/loading/DeleteLoadingService.dart';
import 'package:ujidatapanen/service/loading/ViewLoading_Service.dart';
import 'package:ujidatapanen/screen/AddLoadingScreen.dart';

class ViewLoadingScreen extends StatefulWidget {
  @override
  _ViewLoadingScreenState createState() => _ViewLoadingScreenState();
}

class _ViewLoadingScreenState extends State<ViewLoadingScreen> {
  late Future<List<Loading>> _loadingFuture;
  String searchQuery = '';
  late int userId;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    userId = Provider.of<AuthProvider>(context, listen: false).userId ?? 0;
    _loadingFuture = ViewLoadingService().fetchLoading(userId);
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(BuildContext context, Loading loading) {
    TextEditingController namaLoadingController =
        TextEditingController(text: loading.namaLoading);
    TextEditingController pemilikController =
        TextEditingController(text: loading.pemilik);
    TextEditingController alamatController =
        TextEditingController(text: loading.alamat);
    String? lokasi = loading.lokasi;
    final EditLoadingController _editLoadingController =
        EditLoadingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Loading'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                    child: Text(lokasi ?? 'Lokasi belum dipilih'),
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
                                lokasi = selectedLocation;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String namaLoading = namaLoadingController.text;
                String pemilik = pemilikController.text;
                String alamat = alamatController.text;
                lokasi = lokasi ?? '';

                if (lokasi!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lokasi harus dipilih'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Loading updatedLoading = Loading(
                  id: loading.id,
                  namaLoading: namaLoading,
                  pemilik: pemilik,
                  alamat: alamat,
                  lokasi: lokasi!,
                  userId: loading.userId,
                );

                bool updateSuccess = await _editLoadingController.updateLoading(
                    context, updatedLoading);
                if (updateSuccess) {
                  setState(() {
                    fetchData();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void deleteLoading(BuildContext context, int id) async {
    try {
      bool deleteSuccess = await DeleteLoadingService().deleteLoading(id);
      if (deleteSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil menghapus loading'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          fetchData();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus loading'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan: $e';
      if (e.toString().contains('Loading sedang digunakan!')) {
        errorMessage = 'Loading sedang digunakan!';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void refreshData() {
    setState(() {
      _loadingFuture = ViewLoadingService().fetchLoading(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A4D2E),
        title: Text(
          'Loading',
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
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              showSearchDialog(context);
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            onSelected: (value) {
              if (value == 'Tentang') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TentangView()),
                );
              } else if (value == 'Logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Tentang', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF1A4D2E),
      body: FutureBuilder<List<Loading>>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else {
            final loadingList = snapshot.data!;
            final filteredLoadingList = loadingList.where((loading) {
              return loading.namaLoading.toLowerCase().contains(searchQuery);
            }).toList();

            return ListView.builder(
              itemCount: filteredLoadingList.length,
              itemBuilder: (context, index) {
                final loading = filteredLoadingList[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  height: 80,
                  child: Opacity(
                    opacity: 0.8, // Atur nilai opacity sesuai keinginan
                    child: Card(
                      color: Colors.white
                          .withOpacity(0.10), // Atur warna transparan
                      elevation: 4, // Atur nilai elevation untuk efek 3D
                      child: ListTile(
                        title: Text(
                          loading.namaLoading,
                          style: TextStyle(
                              color: Colors.white), // Sesuaikan warna teks
                        ),
                        subtitle: Text(
                          loading.lokasi,
                          style: TextStyle(
                              color: Colors.white), // Sesuaikan warna teks
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewLoadingDetail(
                                loading: loading,
                                userId: userId,
                              ),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Color.fromARGB(255, 248, 248, 249),
                              onPressed: () {
                                showEditDialog(context, loading);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Color.fromARGB(255, 248, 248, 249),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Loading'),
                                      content: Text(
                                          'Are you sure you want to delete ${loading.namaLoading}?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteLoading(context, loading.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLoadingScreen()),
          ).then((value) {
            if (value != null && value) {
              refreshData();
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
