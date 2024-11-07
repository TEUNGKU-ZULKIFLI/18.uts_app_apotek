import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPemasokScreen extends StatefulWidget {
  const AddPemasokScreen({super.key});

  @override
  State<AddPemasokScreen> createState() => _AddPemasokScreenState();
}

class _AddPemasokScreenState extends State<AddPemasokScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noKontakController = TextEditingController();

  Future<void> addPemasok() async {
    if (namaController.text.isEmpty ||
        alamatController.text.isEmpty ||
        emailController.text.isEmpty ||
        noKontakController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(
          'http://localhost:8080/api_apotek/pemasok_obat/add_pemasok_obat.php'),
      body: {
        'nama_perusahaan': namaController.text,
        'alamat_perusahaan': alamatController.text,
        'email': emailController.text,
        'no_kontak': noKontakController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['success']
              ? 'Data pemasok berhasil ditambahkan'
              : 'Gagal menambahkan pemasok'),
        ),
      );
      if (responseData['success']) Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan pemasok')),
      );
    }
  }

  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black),
      prefixIcon: Icon(icon, color: Colors.lightBlue),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlue),
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
        title: const Text('Tambah Pemasok Obat',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: namaController,
              decoration:
                  _buildInputDecoration('Nama Perusahaan', Icons.business),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: alamatController,
              decoration:
                  _buildInputDecoration('Alamat Perusahaan', Icons.location_on),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: _buildInputDecoration('Email', Icons.email),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noKontakController,
              decoration: _buildInputDecoration('No Kontak', Icons.phone),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: addPemasok,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
