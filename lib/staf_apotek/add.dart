import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddStafScreen extends StatefulWidget {
  @override
  _AddStafScreenState createState() => _AddStafScreenState();
}

class _AddStafScreenState extends State<AddStafScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();
  final TextEditingController _tmpLahirController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();

  Future<void> _addStaf() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api_apotek/staf_apotek/add_staf.php'),
        body: {
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'tgl_lahir': _tglLahirController.text,
          'tmp_lahir': _tmpLahirController.text,
          'no_hp': _noHpController.text,
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        if (result['success']) Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan staf')),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black),
      prefixIcon: Icon(icon, color: Colors.greenAccent),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.greenAccent),
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
        title:
            Text('Tambah Staf Apotek', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: _buildInputDecoration('Nama', Icons.person),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _alamatController,
                decoration: _buildInputDecoration('Alamat', Icons.home),
                validator: (value) => value == null || value.isEmpty
                    ? 'Alamat tidak boleh kosong'
                    : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _tglLahirController,
                decoration: _buildInputDecoration(
                    'Tanggal Lahir (TAHUN-BULAN-TANGGAL)',
                    Icons.calendar_today),
                validator: (value) => value == null || value.isEmpty
                    ? 'Tanggal lahir tidak boleh kosong'
                    : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _tmpLahirController,
                decoration:
                    _buildInputDecoration('Tempat Lahir', Icons.location_on),
                validator: (value) => value == null || value.isEmpty
                    ? 'Tempat lahir tidak boleh kosong'
                    : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _noHpController,
                decoration: _buildInputDecoration('No HP', Icons.phone),
                validator: (value) => value == null || value.isEmpty
                    ? 'No HP tidak boleh kosong'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _addStaf,
                icon: Icon(Icons.save),
                label: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
