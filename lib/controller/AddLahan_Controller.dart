import 'package:flutter/material.dart';
import 'package:ujidatapanen/model/lahan.dart';
import 'package:ujidatapanen/service/addLahan_Service.dart';

class LahanController {
  final LahanService _lahanService = LahanService();

  Future<bool> createLahan(BuildContext context, Lahan lahan) async {
    try {
      bool createSuccess = await _lahanService.createLahan(lahan);
      if (createSuccess) {
        
        return true;
      } else {
        return false;
      }
    } catch (e) {
      
      return false;
    }
  }
}