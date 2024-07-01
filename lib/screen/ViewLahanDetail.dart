import 'package:flutter/material.dart';
import 'package:ujidatapanen/model/lahan.dart';
import 'package:ujidatapanen/model/panen.dart';
import 'package:ujidatapanen/screen/AddPanen_Screen.dart';
import 'package:ujidatapanen/service/ViewPanen_Service.dart';

class ViewLahanDetail extends StatefulWidget {
  final Lahan lahan;

  ViewLahanDetail({required this.lahan});

  @override
  _ViewLahanDetailState createState() => _ViewLahanDetailState();
}

class _ViewLahanDetailState extends State<ViewLahanDetail> with RouteAware {
  late Future<List<Panen>> _panenFuture;

  @override
  void initState() {
    super.initState();
    _loadPanenData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _loadPanenData() {
    setState(() {
      _panenFuture = ViewPanenService().fetchPanen(widget.lahan.id);
    });
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the previous route is shown
    _loadPanenData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Lahan - ${widget.lahan.namaLahan}'),
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
                        'Detail Lahan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      buildInfoRow(Icons.format_size, 'Luas Lahan',
                          '${widget.lahan.luas} Ha'),
                      SizedBox(height: 12),
                      buildInfoRow(
                          Icons.location_on, 'Lokasi', widget.lahan.lokasi),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddPanenScreen(idLahan: widget.lahan.id),
                    ),
                  );
                  if (result == true) {
                    _loadPanenData();
                  }
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(250, 50)),
                ),
                child: Text('Tambahkan Panen', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Panen Dari Lahan ${widget.lahan.namaLahan}',
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
        ],
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 8),
        Text(
          '$label: $value',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }
}

// Global RouteObserver
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
