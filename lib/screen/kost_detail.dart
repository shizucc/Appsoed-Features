import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> dataKost = {
  "id": "kost001",
  "name": "Permata Kost",
  "type": ["L", "P"],
  "images": [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ],
  "region": "Purwokerto",
  "address":
      "Jl Menur RT 07, RW 02, Kalimanah Wetan, Kalimanah, Purbalingga, Jawa Tengah",
  "facilities": [
    "AC",
    "Kamar Mandi dalam",
    "Lapangan Tenis",
    "Security",
    "Music 24 Jam"
  ],
  "location": "Kode apalah yang ada di google maps",
  "price_start_month": 4000000,
  "price_start_year": 40000000,
  "owner": "081390410971"
};

Future<dynamic> getKost() async {
  final response = await http.get(Uri.parse("http://10.0.2.2:8000/kosts/9"));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Something went wrong");
  }
}

// Untuk Mengubah harga menjadi format rupiah
class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp. ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}

// ignore: must_be_immutable
class LocationKost extends StatefulWidget {
  LocationKost({super.key, required this.url});
  final String url;
  late List locs;
  @override
  State<LocationKost> createState() => _LocationKostState();
}

class _LocationKostState extends State<LocationKost> {
  @override
  Widget build(BuildContext context) {
    return const Text("Ini adalah bagian lokasis");
  }
}

// print(runtimeType())
class DetailKost extends StatefulWidget {
  const DetailKost({super.key, required this.id});
  final String id;

  @override
  State<DetailKost> createState() => _DetailKostState();
}

enum AppBarState { expanded, collapsed }

class _DetailKostState extends State<DetailKost> {
  final ScrollController _scrollController = ScrollController();
  late AppBarState _appBarState;
  late int _currentImg;
  late dynamic kost;

  @override
  void initState() {
    super.initState();
    _appBarState = AppBarState.expanded;
    _currentImg = 1;
    _scrollController.addListener(_handleScroll);
    kost = getKost();
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

  Future<dynamic> displayKost() async {
    return kost;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: _appBarState == AppBarState.collapsed
                ? FutureBuilder(
                    future: displayKost(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final name = snapshot.data['name'];
                        return Text(name);
                      } else if (snapshot.hasError) {
                        return Container();
                      } else {
                        return Container(); // Placeholder while loading
                      }
                    })
                // Text(
                //     "nama kost",
                //     style: const TextStyle(color: Colors.black),
                //   )
                : Container(),
            pinned: true,
            snap: false,
            floating: false,
            leading: Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _appBarState == AppBarState.expanded
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : Colors.transparent),
              child: Icon(
                  size: 40,
                  CupertinoIcons.back,
                  color: _appBarState == AppBarState.expanded
                      ? const Color.fromRGBO(255, 183, 49, 1)
                      : Colors.black),
            ),
            expandedHeight: 250,
            flexibleSpace:
                Stack(alignment: AlignmentDirectional.bottomStart, children: [
              FlexibleSpaceBar(
                background: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Builder(
                        builder: (context) {
                          final double height =
                              MediaQuery.of(context).size.height;
                          return FutureBuilder(
                              future: displayKost(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final img = snapshot.data['images'];
                                  final List images =
                                      img.map((e) => e.toString()).toList();
                                  return CarouselSlider(
                                    options: CarouselOptions(
                                        height: height,
                                        viewportFraction: 1.0,
                                        enlargeCenterPage: false,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _currentImg = index + 1;
                                          });
                                        }
                                        // autoPlay: false,
                                        ),
                                    items: images
                                        .map((item) => Center(
                                                child: Image.network(
                                              item,
                                              fit: BoxFit.cover,
                                              height: height,
                                            )))
                                        .toList(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Container();
                                } else {
                                  return Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width: 600,
                                        height: 300,
                                        decoration: const BoxDecoration(
                                            color: Colors.black),
                                      ));
                                }
                              });
                        },
                      ),
                    ]),
              ),
              _appBarState == AppBarState.expanded
                  ? FutureBuilder(
                      future: displayKost(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var imgLength = snapshot.data['images'].length;
                          return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              margin:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7),
                              child: Text("${_currentImg}" + "/${imgLength}"));
                        } else if (snapshot.hasError) {
                          return Container();
                        } else {
                          return Container();
                        }
                      },
                    )
                  : Container()
            ]),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                  padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
                  child: FutureBuilder(
                    future: displayKost(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var kost = snapshot.data;
                        List<String> facilities =
                            kost['facilities'].cast<String>();
                        bool hasP = kost['type'].contains('P');
                        bool hasL = kost['type'].contains('L');

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Judul
                            Text(
                              '${kost['name']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            //Jenis
                            Row(
                              children: [
                                hasL ? const TypeKost(type: 'L') : Container(),
                                hasP ? const TypeKost(type: 'P') : Container(),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // Alamat
                            Row(
                              children: [
                                const Icon(CupertinoIcons.placemark),
                                const SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                  child: Text(
                                    '${kost['address']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                            const Divider(),

                            // Fasilitas
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Fasilitas",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: facilities
                                          .map((facility) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2),
                                                child: Row(children: [
                                                  Icon(
                                                    Icons.circle,
                                                    size: 5,
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  Text(
                                                    facility,
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ]),
                                              ))
                                          .toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Lokasi
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Lokasi",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  LocationKost(
                                      url:
                                          "https://goo.gl/maps/DeVCuD4rCST1azSx6")
                                ],
                              ),
                            ),
                            const Placeholder(
                              fallbackHeight: 30,
                            ),

                            Container(
                                // Ini dipin di bawah layar
                                )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      } else {
                        return const ShimmerArea();
                      }
                    },
                  )),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          height: 90,
          elevation: 0,
          child: FutureBuilder(
            future: displayKost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                bool hasPriceMonth = snapshot.data['price_start_month'] != null;
                bool hasPriceYear = snapshot.data['price_start_year'] != null;
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Mulai dari :",
                            style: TextStyle(fontSize: 17),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                hasPriceMonth
                                    ? Text(
                                        '${CurrencyFormat.convertToIdr(snapshot.data['price_start_month'], 0)} /bulan',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Color.fromRGBO(
                                                253, 183, 49, 1)),
                                      )
                                    : Container(),
                                hasPriceYear
                                    ? Text(
                                        '${CurrencyFormat.convertToIdr(snapshot.data['price_start_year'], 0)} /tahun',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Color.fromRGBO(
                                                253, 183, 49, 1)),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(253, 183, 49, 1),
                          ),
                          child: const Text(
                            "Hubungi Pemilik",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Container();
              } else {
                return const ShimmerBottom();
              }
            },
          )),
    );
  }
}

class TypeKost extends StatelessWidget {
  const TypeKost({super.key, required this.type});
  final String type;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              width: 1, color: type == 'P' ? Colors.red : Colors.blue)),
      child: Text(
        type == 'P' ? 'Wanita' : 'Pria',
        style: TextStyle(
            color: type == 'P' ? Colors.red : Colors.blue,
            fontWeight: FontWeight.w300,
            fontSize: 14),
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer(
      {super.key, required this.width, required this.height});
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(20)),
      width: width,
      height: height,
    );
  }
}

class ShimmerArea extends StatelessWidget {
  const ShimmerArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerContainer(width: 200, height: 25),
            const SizedBox(
              height: 10,
            ),
            //Jenis
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  width: 50,
                  height: 20,
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  width: 50,
                  height: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // // Alamat
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  width: 60,
                  height: 60,
                ),
                const SizedBox(
                  width: 15,
                ),
                const Expanded(
                    child: Column(children: [
                  ShimmerContainer(
                    width: 300,
                    height: 15,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  ShimmerContainer(
                    width: 300,
                    height: 15,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  ShimmerContainer(
                    width: 300,
                    height: 15,
                  )
                ]))
              ],
            ),
            const Divider(),

            // // Fasilitas
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerContainer(
                  height: 17,
                  width: 80,
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(children: [
                    ShimmerContainer(width: 120, height: 12),
                    SizedBox(
                      height: 7,
                    ),
                    ShimmerContainer(width: 120, height: 12),
                    SizedBox(
                      height: 7,
                    ),
                    ShimmerContainer(width: 120, height: 12),
                    SizedBox(
                      height: 7,
                    ),
                    ShimmerContainer(width: 120, height: 12)
                  ]),
                )
              ],
            ),
            // // Lokasi
            const SizedBox(
              height: 10,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerContainer(
                  height: 17,
                  width: 80,
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                    child: ShimmerContainer(
                  height: 150,
                  width: 300,
                ))
              ],
            ),
          ],
        ));
  }
}

class ShimmerBottom extends StatelessWidget {
  const ShimmerBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerContainer(
                  width: 100,
                  height: 15,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerContainer(
                        width: 100,
                        height: 15,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const ShimmerContainer(
                width: 60,
                height: 15,
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
