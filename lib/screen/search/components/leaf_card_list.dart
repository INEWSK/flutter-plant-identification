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
  List<TreeData> _forDisplay = [];

  @override
  void initState() {
    super.initState();
    _forDisplay = widget.provider.treeMap;
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
        ),
        onChanged: (text) {
          text.toLowerCase();
          setState(() {
            _forDisplay = widget.provider.treeMap.where((element) {
              var title = element.commonName.toLowerCase();
              return title.contains(text);
              // 這裏打少個 list 出事
            }).toList();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TreeData> treeData = widget.provider.treeMap;
    return RefreshIndicator(
      onRefresh: () => widget.provider.fetchTreeData(),
      child: ListView.builder(
        itemCount: _forDisplay.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0
              ? _searchBar()
              : _listItem(treeData, index - 1, context);
        },
      ),
    );
  }

  LeafCard _listItem(List<TreeData> treeData, int index, BuildContext context) {
    return LeafCard(
      data: _forDisplay[index],
      press: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetailScreen(data: widget.provider, index: index),
        ),
      ),
    );
  }
}
