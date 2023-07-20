import 'package:appsoed_features/screen/kost_detail.dart.';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> getKosts() async {
  List<Map<String, dynamic>> result = [];
  const url = 'https://good-plum-dugong-wrap.cyclic.app/kos';
  final response = await http.get(Uri.parse(url));

  final datas = jsonDecode(response.body);
  if (datas['status'] == 200) {
    final List<dynamic> kosts = datas['value'];
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
                    padding: EdgeInsets.only(left: 20, top: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
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
                          padding: const EdgeInsets.all(20),
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
                              const KostDatas()
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

class KostDatas extends StatelessWidget {
  const KostDatas({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getKosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return Kosts(kosts: snapshot.data);
        } else if (snapshot.hasError) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset("assets/images/error.png")),
            const Text(
              "Terjadi Kesalahan",
              style: TextStyle(fontSize: 20),
            )
          ]);
        } else {
          return const Column(
            children: [
              KostsShimmer(),
              SizedBox(
                height: 25,
              ),
              KostsShimmer()
            ],
          );
        }
      },
    );
  }
}

class KostsShimmer extends StatelessWidget {
  const KostsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(
              width: MediaQuery.of(context).size.width, height: 150),
          const SizedBox(
            height: 10,
          ),
          const ShimmerContainer(
            width: 150,
            height: 30,
          ),
          const SizedBox(height: 5),
          const ShimmerContainer(height: 25, width: 120),
          const SizedBox(height: 5),
          const Row(children: [
            ShimmerContainer(
              height: 20,
              width: 50,
            ),
            SizedBox(width: 10),
            ShimmerContainer(
              height: 20,
              width: 50,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(child: ShimmerContainer(width: 80, height: 20))
          ])
        ],
      ),
    );
  }
}

class Kosts extends StatelessWidget {
  const Kosts({super.key, required this.kosts});
  final List<dynamic> kosts;
  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 10,
        runSpacing: 30,
        children: kosts.map((kost) {
          return Kost(
            id: kost['id_kos'],
            name: kost['nama_kos'],
            images: const [],
            region: kost['region_kos'],
            types: kost['type_kos'],
            priceStart: kost['price_start'] ?? 0,
          );
        }).toList());
  }
}

// ignore: must_be_immutable
class Kost extends StatelessWidget {
  const Kost(
      {super.key,
      required this.id,
      required this.name,
      required this.images,
      required this.region,
      required this.priceStart,
      required this.types});

  final dynamic id;
  final String name;
  final List images;
  final String region;
  final int priceStart;

  final String types;

  @override
  Widget build(BuildContext context) {
    bool hasPrice = priceStart > 0 ? true : false;
    bool hasImages = images.isNotEmpty ? true : false;
    // var dump = priceStartMonth != 0 ? priceStartMonth : priceStartYear;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DetailKost(id: id)))
        },
        child: Container(
          color: Colors.white,
          // padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: hasImages
                  ? Image.network(images[0])
                  : Image.asset('assets/images/kost.jpg', fit: BoxFit.fill),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
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
                                types == 'L'
                                    ? const TypeKost(type: "L")
                                    : Container(),
                                types == 'P'
                                    ? const TypeKost(type: "P")
                                    : Container(),
                                types == 'Campur'
                                    ? const TypeKost(type: "Campur")
                                    : Container()
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
                              const Text("Mulai dari "),
                              hasPrice
                                  ? Text(
                                      CurrencyFormat.convertToIdr(
                                          priceStart, 0),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromRGBO(0, 0, 0, 0.7),
                                          fontWeight: FontWeight.w300),
                                    )
                                  : Container(),
                            ]),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
