import 'package:flutter/material.dart';
import 'package:ujidatapanen/model/lahan.dart';
import 'package:ujidatapanen/service/EditLahan_service.dart';

class EditLahanDialog extends StatefulWidget {
  final Lahan lahan;

  EditLahanDialog({required this.lahan});

  @override
  _EditLahanDialogState createState() => _EditLahanDialogState();
}

class _EditLahanDialogState extends State<EditLahanDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _namaLahan;
  late String _lokasi;
  late int _luas;

  @override
  void initState() {
    super.initState();
    _namaLahan = widget.lahan.namaLahan;
    _lokasi = widget.lahan.lokasi;
    _luas = widget.lahan.luas;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Lahan'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              initialValue: _namaLahan,
              decoration: InputDecoration(labelText: 'Nama Lahan'),
              onSaved: (value) {
                _namaLahan = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama Lahan tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _lokasi,
              decoration: InputDecoration(labelText: 'Lokasi'),
              onSaved: (value) {
                _lokasi = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lokasi tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _luas.toString(),
              decoration: InputDecoration(labelText: 'Luas'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                _luas = int.parse(value!);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Luas tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Luas harus berupa angka';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false); // Batal tanpa menyimpan
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Lahan updatedLahan = Lahan(
                id: widget.lahan.id,
                namaLahan: _namaLahan,
                lokasi: _lokasi,
                luas: _luas,
                userId: widget.lahan.userId,
              );
              try {
                bool success =
                    await EditLahanService().updateLahan(updatedLahan);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Update berhasil'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context)
                        .pop(true); // Tutup dialog dengan berhasil menyimpan
                  });
                } else {
                  throw Exception('Gagal mengupdate lahan');
                }
              } catch (e) {
                print('Failed to edit lahan: $e');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Failed to Edit Lahan'),
                      content:
                          Text('Terjadi kesalahan saat mengedit lahan: $e'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
        ),
      ],
    );
  }
}
