import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListKost extends StatefulWidget {
  const ListKost({Key? key});

  @override
  State<ListKost> createState() => _ListKostState();
}

class _ListKostState extends State<ListKost> {
  final List<String> kostList = [
    'Kost A',
    'Kost B',
    'Kost C',
    'Kost D',
    'Kost E',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Kost'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.7, // sesuaikan dengan proporsi gambar Anda
        children: List.generate(kostList.length, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KostDetailPage(kostList[index]),
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      'https://example.com/gambar-kost-${index + 1}.jpg', // ganti dengan URL gambar kost sesuai kebutuhan
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kostList[index],
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          'Alamat Kost',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class KostDetailPage extends StatelessWidget {
  final String kostName;

  KostDetailPage(this.kostName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kost'),
      ),
      body: Center(
        child: Text('Detail Kost: $kostName'),
      ),
    );
  }
}
