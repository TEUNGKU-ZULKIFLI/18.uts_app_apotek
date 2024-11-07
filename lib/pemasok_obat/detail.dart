import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit.dart';

class DetailPemasokScreen extends StatelessWidget {
  final Map<String, dynamic> pemasok;

  const DetailPemasokScreen({super.key, required this.pemasok});

  Future<void> deletePemasok(BuildContext context) async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:8080/api_apotek/pemasok_obat/delete_pemasok_obat.php'),
      body: {
        'kode_perusahaan': pemasok['kode_perusahaan'].toString(),
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pemasok berhasil dihapus')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus pemasok')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus pemasok ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal',
                  style: TextStyle(color: Colors.greenAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus',
                  style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
                deletePemasok(context); // Hapus pemasok
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pemasok', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue[400],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detail Pemasok',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text('Nama Perusahaan: ${pemasok['nama_perusahaan']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Alamat Perusahaan: ${pemasok['alamat_perusahaan']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Email: ${pemasok['email']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('No Kontak: ${pemasok['no_kontak']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue[400],
                      ),
                      icon: Icon(Icons.edit),
                      label: Text('Edit'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditPemasokScreen(pemasok: pemasok),
                          ),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      icon: Icon(Icons.delete),
                      label: Text('Hapus'),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
