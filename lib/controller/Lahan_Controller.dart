import 'package:flutter/material.dart';
import 'package:ujidatapanen/model/lahan.dart';
import 'package:ujidatapanen/service/addLahan_Service.dart';

class LahanController {
  final LahanService _lahanService = LahanService();

  Future<bool> createLahan(BuildContext context, Lahan lahan) async {
    try {
      bool createSuccess = await _lahanService.createLahan(lahan);
      if (createSuccess) {
        // Jika pembuatan lahan berhasil, lakukan tindakan sesuai kebutuhan seperti navigasi atau menampilkan pesan sukses
        // Misalnya:
        // Navigator.pop(context);
        // atau menampilkan pesan sukses dengan SnackBar
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Pembuatan lahan berhasil'),
        //   backgroundColor: Colors.green,
        // ));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Jika terjadi kesalahan, tangani error sesuai kebutuhan seperti menampilkan pesan error
      // Misalnya:
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(e.toString()),
      //   backgroundColor: Colors.red,
      // ));
      return false;
    }
  }
}
