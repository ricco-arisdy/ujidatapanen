import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ujidatapanen/provider/AuthProvider.dart';
import 'package:ujidatapanen/screen/AddLoadingScreen.dart';
import 'package:ujidatapanen/service/ViewLoadingService.dart';

class ViewLoadingScreen extends StatefulWidget {
  @override
  _ViewLoadingScreenState createState() => _ViewLoadingScreenState();
}

class _ViewLoadingScreenState extends State<ViewLoadingScreen> {
  late Future<List<dynamic>> _loadingFuture;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    int userId = Provider.of<AuthProvider>(context, listen: false).userId ?? 0;
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
        title: Text('Jumlah Loading'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLoadingScreen()),
              ).then((value) {
                if (value != null && value) {
                  // Refresh data when returning from AddLoadingScreen
                  fetchData();
                  setState(
                      () {}); // Pastikan setState dipanggil untuk memperbarui tampilan
                }
              });
            },
          ),
        ],
      ),
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
    );
  }
}
