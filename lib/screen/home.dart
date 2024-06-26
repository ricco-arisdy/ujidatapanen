import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ujidatapanen/provider/AuthProvider.dart';
import 'package:ujidatapanen/screen/AddLahan_Screen.dart';
import 'package:ujidatapanen/screen/ViewLahan.dart';
import 'package:ujidatapanen/screen/ViewLoadingScreen.dart';
import 'package:ujidatapanen/screen/login_screen.dart';
import 'package:ujidatapanen/screen/tentang_screen.dart';
import 'package:ujidatapanen/service/ViewLahanService.dart';
import 'package:ujidatapanen/model/lahan.dart'; // Import model Lahan yang sesuai

class HomeView extends StatefulWidget {
  final int userId;

  HomeView({required this.userId});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<Lahan>> _lahanFuture; // Menggunakan List<Lahan> daripada List<dynamic>
  String searchQuery = '';
  bool _isTextVisible = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tani Jaya'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog(context);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Tentang':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TentangView()),
                  );
                  break;
                case 'Logout':
                  Provider.of<AuthProvider>(context, listen: false).clearUser();
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
                  child: Text('Logout'),
                ),
              ];
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewLoadingScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 250,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
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
                    Row(
                      children: [
                        Text(
                          'Semua Hasil Panen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
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

                  return ListView.builder(
                    itemCount: filteredLahanList.length,
                    itemBuilder: (context, index) {
                      var lahan = filteredLahanList[index];
                      return Card(
                        child: ListTile(
                          title: Text(lahan.namaLahan),
                          onTap: () {
                            // Navigasi ke halaman ViewPanen dengan membawa data lahan jika diperlukan
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewPanen(lahan: lahan)),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Delete action
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Delete action
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
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
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
