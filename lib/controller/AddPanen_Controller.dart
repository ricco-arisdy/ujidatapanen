import 'package:flutter/material.dart';
import 'package:ujidatapanen/model/panen.dart';
import 'package:ujidatapanen/service/addPanen_Service.dart';

class PanenController {
  final PanenService _panenService = PanenService();

  Future<bool> createPanen(BuildContext context, Panen panen) async {
    try {
      bool createSuccess = await _panenService.createPanen(panen);
      if (createSuccess) {
        // Jika pembuatan panen berhasil, lakukan tindakan sesuai kebutuhan seperti navigasi atau menampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pembuatan panen berhasil'),
          backgroundColor: Colors.green,
        ));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Jika terjadi kesalahan, tangani error sesuai kebutuhan seperti menampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }
}
