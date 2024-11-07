import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPemasokScreen extends StatefulWidget {
  final Map<String, dynamic> pemasok;

  const EditPemasokScreen({super.key, required this.pemasok});

  @override
  State<EditPemasokScreen> createState() => _EditPemasokScreenState();
}

class _EditPemasokScreenState extends State<EditPemasokScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaPerusahaanController;
  late TextEditingController _alamatPerusahaanController;
  late TextEditingController _emailController;
  late TextEditingController _noKontakController;

  @override
  void initState() {
    super.initState();
    _namaPerusahaanController =
        TextEditingController(text: widget.pemasok['nama_perusahaan']);
    _alamatPerusahaanController =
        TextEditingController(text: widget.pemasok['alamat_perusahaan']);
    _emailController = TextEditingController(text: widget.pemasok['email']);
    _noKontakController =
        TextEditingController(text: widget.pemasok['no_kontak']);
  }

  @override
  void dispose() {
    _namaPerusahaanController.dispose();
    _alamatPerusahaanController.dispose();
    _emailController.dispose();
    _noKontakController.dispose();
    super.dispose();
  }

  Future<void> editPemasok() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            'http://localhost:8080/api_apotek/pemasok_obat/edit_pemasok_obat.php'),
        body: {
          'kode_perusahaan': widget.pemasok['kode_perusahaan'].toString(),
          'nama_perusahaan': _namaPerusahaanController.text,
          'alamat_perusahaan': _alamatPerusahaanController.text,
          'email': _emailController.text,
          'no_kontak': _noKontakController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pemasok berhasil diperbarui')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui pemasok')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui pemasok')),
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
        borderSide: BorderSide(color: Colors.lightBlue[400]!),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlue[400]!),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pemasok Obat'),
        backgroundColor: Colors.lightBlue[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaPerusahaanController,
                decoration: _buildInputDecoration('Nama Perusahaan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Perusahaan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _alamatPerusahaanController,
                decoration: _buildInputDecoration('Alamat Perusahaan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat Perusahaan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: _buildInputDecoration('Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _noKontakController,
                decoration: _buildInputDecoration('No Kontak'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No Kontak tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[400],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: editPemasok,
                child: Text('Perbarui'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
