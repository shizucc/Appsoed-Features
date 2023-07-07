import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// final List<String> imgList = [
//   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
//   'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
//   'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
// ];

Map<String, dynamic> kost = {
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
  "address":
      "Jl Menur RT 07, RW 02, Kalimanah Wetan, Kalimanah, Purbalingga, Jawa Tengah",
  "facilities": [
    "AC",
    "Kamar Mandi dalam",
    "Lapangan Tenis",
    "Security",
    "Music 24 Jam"
  ],
  "location": "",
  "price_start": 4000000,
  "owner": "081390404971"
};

List<String> imgList = List<String>.from(kost['images']);

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

  @override
  void initState() {
    super.initState();
    _appBarState = AppBarState.expanded;
    _currentImg = 1;
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
            title: _appBarState == AppBarState.collapsed
                ? Text(
                    kost['name'],
                    style: const TextStyle(color: Colors.black),
                  )
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
                            items: imgList
                                .map((item) => Container(
                                      child: Center(
                                          child: Image.network(
                                        item,
                                        fit: BoxFit.cover,
                                        height: height,
                                      )),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ]),
              ),
              _appBarState == AppBarState.expanded
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      margin: const EdgeInsets.only(left: 10, bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Text("$_currentImg/${imgList.length}"),
                    )
                  : Container()
            ]),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Disini kasih nama kost dan detail lainya
              const Placeholder(
                fallbackHeight: 600,
                color: Colors.red,
              ),
              const Placeholder(
                fallbackHeight: 600,
                color: Colors.blue,
              ),
              const Placeholder(
                fallbackHeight: 600,
                color: Colors.green,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
