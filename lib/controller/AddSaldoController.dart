import 'package:ujidatapanen/service/AddSaldoService.dart';

class AddSaldoController {
  final AddSaldoService _service = AddSaldoService();

  Future<bool> addSaldo(int idLoading, int idUser) async {
    try {
      bool success = await _service.addSaldo(idLoading, idUser);
      return success;
    } catch (e) {
      print('Error adding saldo: $e');
      return false;
    }
  }
}
