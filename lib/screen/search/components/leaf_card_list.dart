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
  void initState() {
    super.initState();
    // widget.provider.fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    List<TreeData> treeData = widget.provider.treeMap;
    // detect(treeData);
    return RefreshIndicator(
      onRefresh: () => widget.provider.fetchTreeData(),
      child: ListView.builder(
        itemCount: treeData.length,
        itemBuilder: (BuildContext context, int index) {
          return LeafCard(
            data: treeData[index],
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

  void detect(List<TreeData> provider) {
    if (provider[0].treeImages.isEmpty) {
      print('tree image null');
    } else {
      print('not null');
    }
  }
}
