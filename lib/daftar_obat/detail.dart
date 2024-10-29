import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit.dart';

class DetailObatScreen extends StatelessWidget {
  final String kode_obat;
  final String nama_obat;
  final String stock;
  final String tgl_kadaluarsa;

  DetailObatScreen({
    required this.kode_obat,
    required this.nama_obat,
    required this.stock,
    required this.tgl_kadaluarsa,
  });

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
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
                _deleteObat(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteObat(BuildContext context) async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:8080/api_apotek/daftar_obat/delete_daftar_obat.php'),
      body: {'kode_obat': kode_obat},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil dihapus')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Obat', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.greenAccent,
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
                Text('Detail Obat',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text('Nama Obat: $nama_obat', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Stock: $stock', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Tanggal Kadaluarsa: $tgl_kadaluarsa',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      ),
                      icon: Icon(Icons.edit),
                      label: Text('Edit'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditObatScreen(
                              kode_obat: kode_obat,
                              nama_obat: nama_obat,
                              stock: stock,
                              tgl_kadaluarsa: tgl_kadaluarsa,
                            ),
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
