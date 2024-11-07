import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StockObatViewHome extends StatefulWidget {
  @override
  _StockObatViewHomeState createState() => _StockObatViewHomeState();
}

class _StockObatViewHomeState extends State<StockObatViewHome> {
  List<dynamic> _listObat = [];
  List<dynamic> _listStock = [];
  String? selectedKodeObat;
  int jumlahStokDiRak = 0;
  int jumlahStokDipesan = 0;
  int sisaStok = 0;

  @override
  void initState() {
    super.initState();
    _fetchObat();
    _fetchStockObat();
  }

  Future<void> _fetchObat() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api_apotek/daftar_obat/get_all_obat.php'));
    if (response.statusCode == 200) {
      setState(() {
        _listObat = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchStockObat() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api_apotek/stock_obat_in_out/get_stock_obat_in_out.php'));
    if (response.statusCode == 200) {
      setState(() {
        _listStock = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  void _calculateSisaStok() {
    final stock = _listStock.firstWhere(
        (item) => item['kode_obat'] == selectedKodeObat,
        orElse: () => null);

    setState(() {
      if (stock != null) {
        jumlahStokDiRak =
            int.tryParse(stock['jumlah_obat_masuk'].toString()) ?? 0;
        jumlahStokDipesan =
            int.tryParse(stock['jumlah_obat_dipesan'].toString()) ?? 0;
      } else {
        jumlahStokDiRak = 0;
        jumlahStokDipesan = 0;
      }
      sisaStok = jumlahStokDiRak - jumlahStokDipesan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lihat Stok Obat", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purpleAccent[400],
      ),
      body: Center(
        // Menggunakan Center untuk menengahkan konten
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Memungkinkan scrolling jika konten melebihi layar
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Membuat kolom sesuai dengan ukuran minimum
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Menengahkan konten
              children: [
                DropdownButton<String>(
                  hint: Text("Pilih Kode Obat"),
                  value: selectedKodeObat,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKodeObat = newValue;
                      _calculateSisaStok();
                    });
                  },
                  items: _listObat.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item['kode_obat'],
                      child:
                          Text('${item['kode_obat']} - ${item['nama_obat']}'),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Jumlah Stok Obat di Rak: $jumlahStokDiRak",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                        Text("Jumlah Stok Obat Dipesan: $jumlahStokDipesan",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                        Text("Sisa Stok Obat: $sisaStok",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateSisaStok,
                  child: Text("Cek"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purpleAccent[400], // Warna tombol
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
