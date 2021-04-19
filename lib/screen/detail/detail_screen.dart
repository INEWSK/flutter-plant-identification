import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';

import 'components/detail_page_widget.dart';

///根據傳進的 treedata 決定顯示什麼 data
class DetailScreen extends StatefulWidget {
  final Result data;

  const DetailScreen({
    Key key,
    @required this.data,
  }) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Result data = widget.data;

    return Scaffold(
      body: DetailPageWidget(
        basicIntro: data.introduction,
        commonName: data.commonName,
        treeImage: data.treeImages.isNotEmpty
            ? data.treeImages.first.treeImage
            : 'http://10.0.2.2:8000/media/images/Bauhinia_blakeana_9hy5snr.jpg',
        scientificName: data.scientificName,
        specialFeatures: data.specialFeatures,
        learnMore: data.toLearnMore,
        leafIntro: data.leaf,
        flowerIntro: data.flower,
        fruitIntro: data.fruit,
        cFamily: data.family,
        cHeight: data.height,
        cNatureLeaf: data.natureOfLeaf,
        cBranch: data.branch,
        cBark: data.bark,
      ),
    );
  }
}
