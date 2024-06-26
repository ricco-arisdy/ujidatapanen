import 'package:flutter/material.dart';
import 'package:ujidatapanen/model/loading.dart';
import 'package:ujidatapanen/service/AddLoading_Service.dart';

class LoadingController {
  final LoadingService _loadingService = LoadingService();

  Future<bool> createLoading(BuildContext context, Loading loading) async {
    try {
      bool createSuccess = await _loadingService.createLoading(loading);
      if (createSuccess) {
        // Jika pembuatan loading berhasil, lakukan tindakan sesuai kebutuhan seperti navigasi atau menampilkan pesan sukses
        // Misalnya:
        // Navigator.pop(context);
        // atau menampilkan pesan sukses dengan SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pembuatan loading berhasil'),
          backgroundColor: Colors.green,
        ));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Jika terjadi kesalahan, tangani error sesuai kebutuhan seperti menampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }
}