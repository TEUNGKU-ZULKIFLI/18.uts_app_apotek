import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add.dart';
import 'detail.dart';
import 'dart:convert';

class StafHome extends StatefulWidget {
  @override
  _StafHomeState createState() => _StafHomeState();
}

class _StafHomeState extends State<StafHome> {
  List stafList = [];
  bool isLoading = true;

  Future<void> fetchStaf() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:8080/api_apotek/staf_apotek/get_staf.php'));

      if (response.statusCode == 200) {
        setState(() {
          stafList = json.decode(response.body);
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
    fetchStaf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DATA STAF APOTEK 👨‍⚕️',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : ListView.builder(
              itemCount: stafList.length,
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
                      stafList[index]['nama'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.green[800]),
                    ),
                    subtitle: Text(
                      stafList[index]['no_hp'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailStafScreen(
                            id: stafList[index]['id'].toString(),
                            nama: stafList[index]['nama'],
                            alamat: stafList[index]['alamat'],
                            tglLahir: stafList[index]['tgl_lahir'],
                            tmpLahir: stafList[index]['tmp_lahir'],
                            noHp: stafList[index]['no_hp'],
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
            MaterialPageRoute(builder: (context) => AddStafScreen()),
          );
        },
      ),
    );
  }
}
