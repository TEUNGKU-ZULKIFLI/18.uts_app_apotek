import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add.dart';

class StockObatHome extends StatefulWidget {
  @override
  _StockObatHomeState createState() => _StockObatHomeState();
}

class _StockObatHomeState extends State<StockObatHome> {
  List stockObatList = [];
  bool isLoading = true;

  Future<void> fetchStockObat() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:8080/api_apotek/stock_obat_in_out/get_stock_obat_in_out.php'));

      if (response.statusCode == 200) {
        setState(() {
          stockObatList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data. Retry in 3 seconds...')),
      );
      await Future.delayed(Duration(seconds: 3));
      fetchStockObat(); // Retry mechanism
    }
  }

  Future<void> deleteStockObat(String id) async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:8080/api_apotek/stock_obat_in_out/delete_stock_obat_in_out.php'),
      body: {'id_stock': id},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil dihapus')),
        );
        fetchStockObat(); // Refresh data after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Gagal menghapus data: ${responseData['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data')),
      );
    }
  }

  void confirmDeleteStockObat(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Data Stok Obat'),
          content: Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteStockObat(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchStockObat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STOK OBAT IN OUT 📦',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent[400],
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.redAccent[400]))
          : ListView.builder(
              itemCount: stockObatList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.redAccent.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ExpansionTile(
                    title: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.redAccent[400],
                        child: Icon(Icons.local_pharmacy, color: Colors.white),
                      ),
                      title: Text(
                        stockObatList[index]['kode_obat']?.toString() ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.redAccent[700],
                        ),
                      ),
                      subtitle: Text(
                        'Jumlah: ${stockObatList[index]['jumlah_obat_masuk'] ?? 0}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent[400]),
                        onPressed: () {
                          confirmDeleteStockObat(
                              stockObatList[index]['id_stock'].toString());
                        },
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Informasi:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tanggal Masuk: ${stockObatList[index]['tgl_obat_masuk'] ?? 'N/A'}',
                            ),
                            Text(
                              'Kode Pemesan: ${stockObatList[index]['kode_pemesan'] ?? 'N/A'}',
                            ),
                            Text(
                              'Nama Pemesan: ${stockObatList[index]['nama_pemesan'] ?? 'N/A'}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent[400],
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStockObatScreen()),
          ).then((_) => fetchStockObat()); // Refresh data after adding
        },
      ),
    );
  }
}
