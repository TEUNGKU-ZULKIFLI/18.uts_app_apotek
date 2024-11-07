import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditObatScreen extends StatefulWidget {
  final String kode_obat;
  final String nama_obat;
  final String stock;
  final String tgl_kadaluarsa;

  EditObatScreen({
    required this.kode_obat,
    required this.nama_obat,
    required this.stock,
    required this.tgl_kadaluarsa,
  });

  @override
  _EditObatScreenState createState() => _EditObatScreenState();
}

class _EditObatScreenState extends State<EditObatScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaObatController;
  late TextEditingController _stockController;
  late TextEditingController _tglKadaluarsaController;

  @override
  void initState() {
    super.initState();
    _namaObatController = TextEditingController(text: widget.nama_obat);
    _stockController = TextEditingController(text: widget.stock);
    _tglKadaluarsaController =
        TextEditingController(text: widget.tgl_kadaluarsa);
  }

  @override
  void dispose() {
    _namaObatController.dispose();
    _stockController.dispose();
    _tglKadaluarsaController.dispose();
    super.dispose();
  }

  Future<void> _updateObat() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            'http://localhost:8080/api_apotek/daftar_obat/edit_daftar_obat.php'),
        body: {
          'kode_obat': widget.kode_obat,
          'nama_obat': _namaObatController.text,
          'stock': _stockController.text,
          'tgl_kadaluarsa': _tglKadaluarsaController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Obat berhasil diperbarui')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal memperbarui obat: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui obat')),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal[400]!),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal[400]!),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Obat'),
        backgroundColor: Colors.teal[400]!,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaObatController,
                decoration: _buildInputDecoration('Nama Obat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Obat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _stockController,
                decoration: _buildInputDecoration('Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stock tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _tglKadaluarsaController,
                decoration: _buildInputDecoration('Tanggal Kadaluarsa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Kadaluarsa tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[400]!,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _updateObat,
                child: Text('Perbarui'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
