import 'package:flutter/material.dart';
import 'package:ujidatapanen/controller/AddLahan_Controller.dart';

class LahanScreen extends StatefulWidget {
  const LahanScreen({super.key});

  @override
  State<LahanScreen> createState() => _LahanScreenState();
}

class _LahanScreenState extends State<LahanScreen> {

  final LahanController _lahanController = LahanController();
  TextEditingController namaLahanController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();
  TextEditingController luasController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}