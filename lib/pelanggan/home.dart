import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add.dart';
import 'detail.dart';
import 'dart:convert';

class PelangganHome extends StatefulWidget {
  @override
  _PelangganHomeState createState() => _PelangganHomeState();
}

class _PelangganHomeState extends State<PelangganHome> {
  List pelangganList = [];
  bool isLoading = true;

  Future<void> fetchPelanggan() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:8080/api_apotek/pelanggan/get_pelanggan.php'));

      if (response.statusCode == 200) {
        setState(() {
          pelangganList = json.decode(response.body);
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
    fetchPelanggan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DATA PELANGGAN 👤',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            )
          : ListView.builder(
              itemCount: pelangganList.length,
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
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      pelangganList[index]['nama'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.green[800]),
                    ),
                    subtitle: Text(
                      pelangganList[index]['no_hp'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPelangganScreen(
                            id: pelangganList[index]['id'].toString(),
                            nama: pelangganList[index]['nama'],
                            alamat: pelangganList[index]['alamat'],
                            noHp: pelangganList[index]['no_hp'],
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
            MaterialPageRoute(builder: (context) => AddPelangganScreen()),
          );
        },
      ),
    );
  }
}
