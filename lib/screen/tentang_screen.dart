import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujidatapanen/screen/home.dart';

class TentangView extends StatefulWidget {
  @override
  _TentangViewState createState() => _TentangViewState();
}

class _TentangViewState extends State<TentangView> {
  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _email = prefs.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            maxWidth: 300, // Sesuaikan ukuran maksimal container
          ),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Menyesuaikan ukuran container dengan kontennya
            crossAxisAlignment:
                CrossAxisAlignment.start, // Menyelaraskan teks di sebelah kiri
            children: <Widget>[
              Text(
                'Username: $_username',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10), // Tambahkan jarak antara username dan email
              Text(
                'Email: $_email',
                style: TextStyle(fontSize: 20),
              ),
              // Anda dapat menambahkan widget lainnya di sini sesuai kebutuhan
            ],
          ),
        ),
      ),
    );
  }
}
