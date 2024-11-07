import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddObatScreen extends StatefulWidget {
  @override
  _AddObatScreenState createState() => _AddObatScreenState();
}

class _AddObatScreenState extends State<AddObatScreen> {
  final TextEditingController _namaObatController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _tglKadaluarsaController =
      TextEditingController();

  Future<void> _addObat() async {
    if (_namaObatController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _tglKadaluarsaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(
          'http://localhost:8080/api_apotek/daftar_obat/add_daftar_obat.php'),
      body: {
        'nama_obat': _namaObatController.text,
        'stock': _stockController.text,
        'tgl_kadaluarsa': _tglKadaluarsaController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(responseData['success']
                ? 'Data obat berhasil ditambahkan'
                : 'Gagal menambahkan obat')),
      );
      if (responseData['success']) Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan obat')),
      );
    }
  }

  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black),
      prefixIcon: Icon(icon, color: Colors.teal[400]!),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal[400]!),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Obat', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[400]!,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaObatController,
              decoration:
                  _buildInputDecoration('Nama Obat', Icons.medical_services),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _stockController,
              decoration: _buildInputDecoration('Stock', Icons.storage),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _tglKadaluarsaController,
              decoration: _buildInputDecoration(
                  'Tanggal Kadaluarsa (TAHUN-BULAN-TANGGAL)',
                  Icons.calendar_today),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _addObat,
                icon: Icon(Icons.save),
                label: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[400]!,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
