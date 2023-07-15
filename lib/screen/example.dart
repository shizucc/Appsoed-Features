import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // Background Container
          color: Colors.blue, // Warna latar belakang
        ),
        Align(
          alignment: Alignment.topCenter,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                // Container berisi konten
                child: Text("Hello"),
              );
            },
          ),
        ),
      ],
    );
  }
}
