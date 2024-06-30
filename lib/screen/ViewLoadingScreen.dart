import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ujidatapanen/provider/AuthProvider.dart';
import 'package:ujidatapanen/screen/AddLoadingScreen.dart';
import 'package:ujidatapanen/screen/home.dart';
import 'package:ujidatapanen/screen/login_screen.dart';
import 'package:ujidatapanen/screen/tentang_screen.dart';
import 'package:ujidatapanen/service/ViewLoadingService.dart';

class ViewLoadingScreen extends StatefulWidget {
  @override
  _ViewLoadingScreenState createState() => _ViewLoadingScreenState();
}

class _ViewLoadingScreenState extends State<ViewLoadingScreen> {
  late Future<List<dynamic>> _loadingFuture;
  String searchQuery = '';
  late int userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<AuthProvider>(context, listen: false).userId ?? 0;
    fetchData();
  }

  void fetchData() {
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
        ],
      ),
      backgroundColor: Color(0xFF1A4D2E),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _loadingFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  List<dynamic> loadingList = snapshot.data!;
                  List<dynamic> filteredLoadingList =
                      loadingList.where((loading) {
                    return loading['nama_loading']
                        .toLowerCase()
                        .contains(searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredLoadingList.length,
                    itemBuilder: (context, index) {
                      var loading = filteredLoadingList[index];
                      return Card(
                        child: ListTile(
                          title: Text(loading['nama_loading']),
                          subtitle: Text('Pemilik: ${loading['pemilik']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Edit action
                                },
                                child: Text('Edit'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Delete action
                                },
                                child: Text('Del'),
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
                      builder: (context) => HomeView(userId: userId),
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
            MaterialPageRoute(builder: (context) => AddLoadingScreen()),
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
