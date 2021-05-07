import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_hotelapp/models/tree_locations.dart' as lct;
// import 'package:flutter_hotelapp/models/tree_data.dart';

import 'components/detail_page_widget.dart';

enum DataType { GoogleMap, Tree }

///根據傳進的 treedata 決定顯示什麼 data
class DetailScreen extends StatefulWidget {
  final data;
  final DataType type;

  const DetailScreen({
    Key key,
    @required this.data,
    @required this.type,
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
    if (widget.type == DataType.GoogleMap) {
      lct.TreeLocation data = widget.data;
      return Scaffold(
        body: DetailPageWidget(
          basicIntro: data.introduction,
          commonName: data.commonName,
          treeImage: data.treeLocations.isNotEmpty
              ? data.treeLocations.first.treeImage
              : null,
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
    } else {
      Result data = widget.data;
      return Scaffold(
        body: DetailPageWidget(
          basicIntro: data.introduction,
          commonName: data.commonName,
          treeImage: data.treeImages.isNotEmpty
              ? data.treeImages.first.treeImage
              : null,
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
}
