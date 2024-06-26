import 'package:flutter/material.dart';
import 'package:ujidatapanen/model/lahan.dart'; // Sesuaikan dengan lokasi dan nama model Lahan Anda

class ViewPanen extends StatefulWidget {
  final Lahan lahan;

  ViewPanen({required this.lahan});

  @override
  _ViewPanenState createState() => _ViewPanenState();
}

class _ViewPanenState extends State<ViewPanen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Panen - ${widget.lahan.namaLahan}'),
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            height: 200,
            width: 350,
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
                    'Detail Panen',
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
