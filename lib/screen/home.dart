import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ujidatapanen/controller/Edit_Lahan_Dialog.dart';
import 'package:ujidatapanen/provider/AuthProvider.dart';
import 'package:ujidatapanen/screen/AddLahan_Screen.dart';
import 'package:ujidatapanen/screen/ViewLahanDetail.dart';
import 'package:ujidatapanen/screen/ViewLoadingScreen.dart';
import 'package:ujidatapanen/screen/login_screen.dart';
import 'package:ujidatapanen/screen/tentang_screen.dart';
import 'package:ujidatapanen/service/ViewLahanService.dart';
import 'package:ujidatapanen/model/lahan.dart';
import 'package:ujidatapanen/service/deleteLahanService.dart';

class HomeView extends StatefulWidget {
  final int userId;

  HomeView({required this.userId});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<Lahan>> _lahanFuture;
  String searchQuery = '';
  bool _isTextVisible = true;
  final LahanService _lahanService =
      LahanService(); // Instance of LahanService for delete operation

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    _lahanFuture = ViewLahanService().fetchLahan(widget.userId);
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Ubah radius border
          ),
          contentPadding:
              EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0), // Atur padding konten

          content: TextField(
            style: TextStyle(fontSize: 16), // Ubah ukuran teks pada TextField
            decoration: InputDecoration(
              labelText: 'Search',
              labelStyle: TextStyle(fontSize: 16), // Ukuran teks label
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
              child: Text(
                'Close',
                style: TextStyle(fontSize: 16), // Ukuran teks tombol
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteLahan(int id) async {
    try {
      await _lahanService.deleteLahan(id);
      setState(() {
        fetchData();
      });
    } catch (e) {
      // Handle error jika penghapusan gagal
      print('Failed to delete lahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1A4D2E),
        title: Text(
          'Tani Jaya Company',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      backgroundColor: Color(0xFF1A4D2E),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 250,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                elevation: 20, // Menentukan nilai elevation untuk efek 3D
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF059212),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hasil Panen Semua Lahan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          AnimatedOpacity(
                            opacity: _isTextVisible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  _isTextVisible ? 'Kg 1000' : '...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!_isTextVisible)
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isTextVisible = !_isTextVisible;
                              });
                            },
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                if (!_isTextVisible)
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        'assets/line.svg',
                                        color: Colors.white,
                                        height: 18,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 2,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Lahan>>(
              future: _lahanFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  List<Lahan> lahanList = snapshot.data!;
                  List<Lahan> filteredLahanList = lahanList.where((lahan) {
                    return lahan.namaLahan.toLowerCase().contains(searchQuery);
                  }).toList();

                  return Container(
                    height: 400,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: filteredLahanList.length,
                      itemBuilder: (context, index) {
                        var lahan = filteredLahanList[index];
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                          height: 80,
                          child: Opacity(
                            opacity: 0.8, // Atur nilai opacity sesuai keinginan
                            child: Card(
                              color: Colors.white
                                  .withOpacity(0.10), // Atur warna transparan
                              elevation:
                                  4, // Atur nilai elevation untuk efek 3D
                              child: ListTile(
                                title: Text(
                                  lahan.namaLahan,
                                  style: TextStyle(
                                      color:
                                          Colors.white), // Sesuaikan warna teks
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewLahanDetail(lahan: lahan),
                                    ),
                                  );
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Color.fromARGB(255, 248, 248, 249),
                                      onPressed: () async {
                                        bool? updated = await showDialog(
                                          context: context,
                                          builder: (context) =>
                                              EditLahanDialog(lahan: lahan),
                                        );
                                        if (updated != null && updated) {
                                          setState(() {
                                            fetchData(); // Refresh data setelah edit
                                          });
                                        }
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
                                              title: Text('Delete Lahan'),
                                              content: Text(
                                                  'Are you sure you want to delete ${lahan.namaLahan}?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Delete'),
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    await _deleteLahan(lahan
                                                        .id); // Panggil fungsi delete
                                                  },
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
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Color(0xFF059212),
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeView(userId: widget.userId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearchDialog(context);
                },
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewLoadingScreen()),
                  );
                },
              ),
              PopupMenuButton<String>(
                icon: Icon(
                    Icons.person), // Menentukan ikon yang ingin ditampilkan
                onSelected: (value) {
                  switch (value) {
                    case 'Tentang':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TentangView()),
                      );
                      break;
                    case 'Logout':
                      Provider.of<AuthProvider>(context, listen: false)
                          .clearUser();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'Tentang',
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 15,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Tentang',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'Logout',
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            size: 15,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LahanScreen()),
          );
          if (added != null && added) {
            setState(() {
              fetchData();
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 191, 200, 205),
        shape: CircleBorder(),
        elevation: 8.0,
      ),
    );
  }
}
