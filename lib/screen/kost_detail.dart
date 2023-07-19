import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

// Mengambil data dari API
Future<dynamic> getKost(dynamic id) async {
  final response = await http.get(Uri.parse("http://10.0.2.2:8000/kosts/$id"));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Something went wrong");
  }
}

void openMap(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {}
}

void openWhatsApp(String owner, String name) async {
  String phoneNumber = owner;
  String message =
      "Permisi, saya ingin bertanya ketersediaan kamar kost di $name";
  final url = "https://wa.me/$phoneNumber?text=$message}";
  // final url = 'https://google.com';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {}
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
  final dynamic id;

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
    kost = getKost(widget.id);
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
      body: Container(
        child: CustomScrollView(
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
                  : Container(),
              pinned: true,
              snap: false,
              floating: false,
              stretch: true,
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
                                    final name = snapshot.data['name'];
                                    final List images =
                                        img.map((e) => e.toString()).toList();
                                    return CarouselSlider(
                                      options: CarouselOptions(
                                          height: height,
                                          viewportFraction: 1.0,
                                          enlargeCenterPage: false,
                                          initialPage: _currentImg - 1,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _currentImg = index + 1;
                                            });
                                          }
                                          // autoPlay: false,
                                          ),
                                      items: images
                                          .map((item) => InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewImage(
                                                                  name: name,
                                                                  images:
                                                                      images,
                                                                  currentImage:
                                                                      _currentImg)));
                                                },
                                                child: Center(
                                                    child: Image.network(
                                                  item,
                                                  fit: BoxFit.cover,
                                                  height: height,
                                                )),
                                              ))
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
                            return ClipRRect(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  margin: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 7),
                                  child: Text("$_currentImg" + "/$imgLength")),
                            );
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
                    padding:
                        const EdgeInsets.only(top: 20, left: 25, right: 25),
                    child: FutureBuilder(
                      future: displayKost(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var kost = snapshot.data;
                          List<String> facilities =
                              kost['facilities'].cast<String>();
                          bool hasP = kost['type'].contains('P');
                          bool hasL = kost['type'].contains('L');

                          bool hasLocation =
                              kost['location'] == null ? false : true;
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
                                  hasL
                                      ? const TypeKost(type: 'L')
                                      : Container(),
                                  hasP
                                      ? const TypeKost(type: 'P')
                                      : Container(),
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                    Expanded(
                                                      child: Text(
                                                        facility,
                                                        style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.8),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
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
                              hasLocation
                                  ? Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Lokasi",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () =>
                                                {openMap(kost['location'])},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Image.asset(
                                                  'assets/images/location_kost.png',
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child:
                                      Image.asset("assets/images/error.png")),
                              const Text(
                                "Terjadi Kesalahan",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          );
                        } else {
                          return const ShimmerArea();
                        }
                      },
                    )),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ]),
        child: BottomAppBar(
            height: 90,
            elevation: 0,
            child: FutureBuilder(
              future: displayKost(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  bool hasPriceMonth =
                      snapshot.data['price_start_month'] != null;
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
                        child: InkWell(
                          onTap: () => openWhatsApp(
                              snapshot.data['owner'], snapshot.data['name']),
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(253, 183, 49, 1)),
                              child: const Text(
                                "Hubungi Pemilik",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )),
                        ),
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
      ),
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

class ViewImage extends StatefulWidget {
  const ViewImage(
      {super.key,
      required this.name,
      required this.images,
      required this.currentImage});
  final List<dynamic> images;
  final int currentImage;
  final String name;
  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
            onTap: () => {Navigator.pop(context)},
            child: const Icon(CupertinoIcons.back, color: Colors.white)),
        title: Text(widget.name, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            final double height = MediaQuery.of(context).size.height;
            return CarouselSlider(
              options: CarouselOptions(
                height: height,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                initialPage: widget.currentImage - 1,
              ),
              items: widget.images
                  .map((item) => Container(
                        child: Center(
                            child: Image.network(
                          item,
                          fit: BoxFit.cover,
                        )),
                      ))
                  .toList(),
            );
          },
        ),
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
  }
}
