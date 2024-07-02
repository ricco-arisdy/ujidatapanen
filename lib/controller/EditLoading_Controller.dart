import 'package:flutter/material.dart';
import 'package:ujidatapanen/model/loading.dart';
import 'package:ujidatapanen/service/EditLoading_Service.dart';

class EditLoadingController {
  final EditLoadingService _editLoadingService = EditLoadingService();

  Future<bool> updateLoading(BuildContext context, Loading loading) async {
    try {
      bool updateSuccess = await _editLoadingService.updateLoading(loading);
      if (updateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pembaruan loading berhasil'),
          backgroundColor: Colors.green,
        ));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }
}
