import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add.dart';
import 'detail.dart';

class PemasokObatHome extends StatefulWidget {
  const PemasokObatHome({super.key});

  @override
  State<PemasokObatHome> createState() => _PemasokObatHomeState();
}

class _PemasokObatHomeState extends State<PemasokObatHome> {
  List pemasokList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPemasok();
  }

  Future<void> fetchPemasok() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:8080/api_apotek/pemasok_obat/get_pemasok_obat.php'));

      if (response.statusCode == 200) {
        setState(() {
          pemasokList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load pemasok');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DAFTAR PEMASOK OBAT 🫂💊',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue[400],
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.lightBlue[400]))
          : ListView.builder(
              itemCount: pemasokList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.lightBlue.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.lightBlue[700],
                      child: Icon(Icons.location_city, color: Colors.white),
                    ),
                    title: Text(
                      pemasokList[index]['nama_perusahaan'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.lightBlue[700]),
                    ),
                    subtitle: Text(
                      pemasokList[index]['no_kontak'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Colors.lightBlue[400]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPemasokScreen(pemasok: pemasokList[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue[400],
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPemasokScreen()),
          ).then((_) => fetchPemasok());
        },
      ),
    );
  }
}
