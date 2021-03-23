import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';
import 'package:flutter_hotelapp/screen/search/provider/tree_data_provider.dart';

import 'leaf_card.dart';

class LeafCardList extends StatefulWidget {
  final BuildContext context;
  final TreeDataProvider provider;

  const LeafCardList({Key key, this.provider, this.context}) : super(key: key);

  @override
  _LeafCardListState createState() => _LeafCardListState();
}

class _LeafCardListState extends State<LeafCardList> {
  @override
  Widget build(BuildContext context) {
    List<TreeData> data = widget.provider.treeMap;
    return RefreshIndicator(
      onRefresh: () => widget.provider.fetchTreeData(),
      child: ListView.builder(
        // shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return LeafCard(
            title: data[index].commonName,
            imgSrc: 'assets/images/bauhinia_blakeana.jpg', //api目前沒有提供圖片
            sname: data[index].scientificName,
            intro: data[index].introduction,
            press: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailScreen(data: widget.provider, index: index),
              ),
            ),
          );
        },
      ),
    );
  }
}
