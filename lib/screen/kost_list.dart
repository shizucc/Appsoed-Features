import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaftarRumah extends StatefulWidget {
  @override
  _DaftarRumahState createState() => _DaftarRumahState();
}

class _DaftarRumahState extends State<DaftarRumah> {
  List<dynamic> rumahList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.example.com/rumah'));

    if (response.statusCode == 200) {
      setState(() {
        rumahList = jsonDecode(response.body);
      });
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Rumah'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // Mengakses data rumah pada indeks tertentu
                dynamic rumah = rumahList[index];

                return ListTile(
                  title: Text(rumah['nama']),
                  subtitle: Text(rumah['alamat']),
                  // Tambahkan informasi lain yang kamu inginkan
                );
              },
              childCount: rumahList.length,
            ),
          ),
        ],
      ),
    );
  }
}
