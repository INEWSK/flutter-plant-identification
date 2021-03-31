import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_hotelapp/screen/search/provider/tree_data_provider.dart';

import 'components/detail_page_widget.dart';

///根據傳進的 index 決定顯示什麼 data
class DetailScreen extends StatefulWidget {
  final TreeDataProvider data;
  final int index;

  const DetailScreen({Key key, this.data, this.index}) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String noInfo = 'No More Information';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TreeData data = widget.data.treeMap[widget.index];

    return Scaffold(
      body: DetailPageWidget(
        basicIntro: data.introduction.isEmpty ?? noInfo,
        commonName: data.commonName.isEmpty ?? noInfo,
        treeImage: data.treeImages.isNotEmpty
            ? data.treeImages[0].treeImage
            : 'http://10.0.2.2:8000/media/images/Bauhinia_blakeana_9hy5snr.jpg',
        scientificName: data.scientificName.isEmpty ?? noInfo,
        specialFeatures: data.specialFeatures.isEmpty ?? noInfo,
        learnMore: data.toLearnMore.isEmpty ?? noInfo,
        leafIntro: data.leaf.isEmpty ?? noInfo,
        flowerIntro: data.flower.isEmpty ?? noInfo,
        fruitIntro: data.fruit.isEmpty ?? noInfo,
        cFamily: data.family,
        cHeight: data.height,
        cNatureLeaf: data.natureOfLeaf,
        cBranch: data.branch,
        cBark: data.bark,
      ),
    );
  }
}
