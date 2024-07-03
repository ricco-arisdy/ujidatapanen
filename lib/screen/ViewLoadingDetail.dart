import 'package:flutter/material.dart';
import 'package:ujidatapanen/controller/AddSaldoController.dart';
import 'package:ujidatapanen/model/loading.dart';
import 'package:ujidatapanen/model/panen.dart';
import 'package:ujidatapanen/screen/AddLoadingScreen.dart';
import 'package:ujidatapanen/service/ViewPanenServicebyLoading.dart';

class ViewLoadingDetail extends StatefulWidget {
  final Loading loading;
  final int userId;

  ViewLoadingDetail({
    required this.loading,
    required this.userId,
  });

  @override
  _ViewLoadingDetailState createState() => _ViewLoadingDetailState();
}

class _ViewLoadingDetailState extends State<ViewLoadingDetail> {
  late Future<List<Panen>> _panenFuture;

  @override
  void initState() {
    super.initState();
    _loadPanenData();
  }

  void _loadPanenData() {
    setState(() {
      _panenFuture = ViewPanenServiceLoading().fetchPanen(widget.loading.id);
    });
  }

  void _addSaldoAndDeletePanen() async {
    try {
      bool success =
          await AddSaldoController().addSaldo(widget.loading.id, widget.userId);
      if (success) {
        _loadPanenData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menjual panen')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Panen berhasil dijual dan saldo ditambahkan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Loading - ${widget.loading.namaLoading}'),
        backgroundColor: Color(0xFF1A4D2E),
      ),
      backgroundColor: Color(0xFF1A4D2E),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blueAccent,
                      Colors.pinkAccent,
                      Colors.orangeAccent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Loading',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      buildInfoRow(
                        Icons.person,
                        'Pemilik',
                        widget.loading.pemilik,
                      ),
                      SizedBox(height: 12),
                      buildInfoRow(
                        Icons.location_on,
                        'Alamat',
                        widget.loading.alamat,
                      ),
                      SizedBox(height: 12),
                      buildInfoRow(
                        Icons.location_on,
                        'Lokasi',
                        widget.loading.lokasi,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Panen Dari Loading ${widget.loading.namaLoading}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Panen>>(
              future: _panenFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  List<Panen> panenList = snapshot.data!;
                  return ListView.builder(
                    itemCount: panenList.length,
                    itemBuilder: (context, index) {
                      var panen = panenList[index];
                      return Card(
                        child: ListTile(
                          title: Text(panen.noPanen),
                          subtitle: Text('Jumlah: ${panen.jumlah} Kg'),
                          trailing: Text('Harga: ${panen.harga}'),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _addSaldoAndDeletePanen();
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(250, 50)),
                ),
                child: Text('Jual Panen', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 8),
        Expanded(
          // Expanded to make sure the text wraps within the available space
          child: Text(
            '$label: $value',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
