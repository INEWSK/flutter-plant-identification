import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/detail/components/detail_widget.dart';

class DetailTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetailPageWidget(
        imageUrl: 'assets/images/image_header.png',
        commonName: 'test',
        scientificName: 'test',
        chineseName: 'null',
        basicIntro: 'null',
      ),
    );
  }
}
