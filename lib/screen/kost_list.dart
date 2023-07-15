import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appsoed_features/screen/kost_detail.dart'
    show TypeKost, CurrencyFormat;

Future<dynamic> getKosts() async {
  List<Map<String, dynamic>> result = [];
  final response = await http.get(Uri.parse("http://10.0.2.2:8000/kosts"));
  if (response.statusCode == 200) {
    final List<dynamic> kosts = jsonDecode(response.body);
    result = kosts.map((kost) => Map<String, dynamic>.from(kost)).toList();
    return result;
  } else {
    throw Exception("Something went wrong");
  }
}

class ListKost extends StatefulWidget {
  const ListKost({Key? key});

  @override
  State<ListKost> createState() => _ListKostState();
}

enum AppBarState { expanded, collapsed }

class _ListKostState extends State<ListKost> {
  final ScrollController _scrollController = ScrollController();
  late AppBarState _appBarState;
  final List<String> kostList = [
    'Kost A',
    'Kost B',
    'Kost C',
    'Kost D',
    'Kost E',
  ];

  @override
  void initState() {
    super.initState();
    _appBarState = AppBarState.expanded;
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.offset > 150 &&
        _appBarState == AppBarState.expanded) {
      setState(() {
        _appBarState = AppBarState.collapsed;
      });
    } else if (_scrollController.offset <= 150 &&
        _appBarState == AppBarState.collapsed) {
      setState(() {
        _appBarState = AppBarState.expanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
              leading: Container(
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _appBarState == AppBarState.expanded
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : Colors.transparent),
                child: InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: Icon(
                      size: 30,
                      CupertinoIcons.back,
                      color: _appBarState == AppBarState.expanded
                          ? const Color.fromRGBO(255, 183, 49, 1)
                          : Colors.black),
                ),
              ),
              title: _appBarState == AppBarState.collapsed
                  ? const Text("Info Kost")
                  : Container(),
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 183, 49, 1)),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lagi Cari Kos - Kosan ?",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Coba liat-liat dulu sini",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              )),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              color: const Color.fromRGBO(241, 239, 239, 1),
              child: Stack(
                children: [
                  Container(
                      color: _appBarState == AppBarState.expanded
                          ? const Color.fromRGBO(255, 183, 49, 1)
                          : Colors.transparent,
                      height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                        alignment: Alignment.topCenter,
                        // padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _appBarState == AppBarState.expanded
                                ? Colors.white
                                : const Color.fromRGBO(241, 239, 239, 1)),
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Container(
                                  width: 40,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          _appBarState == AppBarState.expanded
                                              ? const Color.fromRGBO(
                                                  217, 217, 217, 1)
                                              : Colors.transparent),
                                ),
                              ),
                              const MyList3()
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          ]))
        ],
      ),
    );
  }
}

class MyList4 extends StatelessWidget {
  const MyList4({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyList2 extends StatelessWidget {
  const MyList2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.red,
    );
  }
}

class MyList3 extends StatelessWidget {
  const MyList3({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getKosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print(snapshot.data[1]);
          return Kosts(kosts: snapshot.data);
        } else if (snapshot.hasError) {
          return const Text("Something went wrong");
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class Kosts extends StatelessWidget {
  const Kosts({super.key, required this.kosts});
  final List<dynamic> kosts;
  @override
  Widget build(BuildContext context) {
    // print(kosts);
    return Wrap(
        spacing: 10,
        runSpacing: 30,
        children: kosts.map((kost) {
          return Kost(
            name: kost['name'],
            images: kost['images'],
            region: kost['region'],
            types: kost['type'],
            priceStartMonth: kost['price_start_month'] ?? 0,
            priceStartYear: kost['price_start_year'] ?? 0,
          );
        }).toList());
  }
}

// ignore: must_be_immutable
class Kost extends StatelessWidget {
  const Kost(
      {super.key,
      required this.name,
      required this.images,
      required this.region,
      required this.priceStartMonth,
      required this.priceStartYear,
      required this.types});

  final String name;
  final List images;
  final String region;
  final int priceStartMonth;
  final int priceStartYear;
  final List<dynamic> types;

  @override
  Widget build(BuildContext context) {
    bool hasPriceMonth = priceStartMonth != 0 ? true : false;
    bool hasPriceYear = priceStartYear != 0 ? true : false;
    // var dump = priceStartMonth != 0 ? priceStartMonth : priceStartYear;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: Colors.white,
        // padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(images[0])),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 22),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.placemark,
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                ),
                                Text(
                                  region,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(0, 0, 0, 0.5)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            runSpacing: 7,
                            children: [
                              types.contains('L')
                                  ? const TypeKost(type: "L")
                                  : Container(),
                              types.contains('P')
                                  ? const TypeKost(type: "P")
                                  : Container(),
                            ],
                          )
                        ],
                      )),
                    ),
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            hasPriceMonth
                                ? Text(
                                    '${CurrencyFormat.convertToIdr(priceStartMonth, 0)}/bln',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(0, 0, 0, 0.7),
                                        fontWeight: FontWeight.w300),
                                  )
                                : Container(),
                            hasPriceYear
                                ? Text(
                                    '${CurrencyFormat.convertToIdr(priceStartYear, 0)}/thn',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(0, 0, 0, 0.7),
                                        fontWeight: FontWeight.w300))
                                : Container()
                          ]),
                    )
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class MyList extends StatelessWidget {
  const MyList({
    super.key,
    required this.kostList,
  });

  final List<String> kostList;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
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
    );
  }
}

class KostDetailPage extends StatelessWidget {
  const KostDetailPage(this.kostName, {super.key});
  final String kostName;

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
