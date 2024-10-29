import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add.dart';
import 'detail.dart';
import 'dart:convert';

class DaftarObatHome extends StatefulWidget {
  @override
  _DaftarObatHomeState createState() => _DaftarObatHomeState();
}

class _DaftarObatHomeState extends State<DaftarObatHome> {
  List daftarObatList = [];
  bool isLoading = true;

  Future<void> fetchDaftarObat() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:8080/api_apotek/daftar_obat/get_daftar_obat.php'));

      if (response.statusCode == 200) {
        setState(() {
          daftarObatList = json.decode(response.body);
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
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDaftarObat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DAFTAR OBAT 💊',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : ListView.builder(
              itemCount: daftarObatList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.greenAccent.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.greenAccent[700],
                      child: Icon(Icons.medical_services, color: Colors.white),
                    ),
                    title: Text(
                      daftarObatList[index]['nama_obat'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.green[800]),
                    ),
                    subtitle: Text(
                      'Stock: ${daftarObatList[index]['stock']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    trailing: Text(
                      'Exp: ${daftarObatList[index]['tgl_kadaluarsa']}',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailObatScreen(
                            kode_obat:
                                daftarObatList[index]['kode_obat'].toString(),
                            nama_obat: daftarObatList[index]['nama_obat'],
                            stock: daftarObatList[index]['stock'].toString(),
                            tgl_kadaluarsa: daftarObatList[index]
                                ['tgl_kadaluarsa'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddObatScreen()),
          );
        },
      ),
    );
  }
}
