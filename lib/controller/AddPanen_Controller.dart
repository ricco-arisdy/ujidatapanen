import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ujidatapanen/model/panen.dart';
import 'package:ujidatapanen/service/panen/addPanen_Service.dart';

class PanenController {
  final PanenService _panenService = PanenService();

  Future<bool> createPanen(BuildContext context, Panen panen,
      {File? imageFile}) async {
    try {
      bool createSuccess = await _panenService.createPanen(panen, imageFile);
      if (createSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pembuatan panen berhasil'),
          backgroundColor: Colors.green,
        ));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }
}
