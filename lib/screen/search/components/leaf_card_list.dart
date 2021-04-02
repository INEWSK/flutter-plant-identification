import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';

import '../provider/tree_data_provider.dart';
import 'leaf_card.dart';

class LeafCardList extends StatefulWidget {
  final BuildContext context;
  final TreeDataProvider provider;

  const LeafCardList({Key key, this.provider, this.context}) : super(key: key);

  @override
  _LeafCardListState createState() => _LeafCardListState();
}

class _LeafCardListState extends State<LeafCardList> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<TreeData> _treeData = [];
  List<TreeData> _displayListItem = [];

  @override
  void dispose() {
    super.dispose();
    _focusNode?.dispose();
    _textController?.dispose();
    _treeData = widget.provider.treeMap;
  }

  @override
  void initState() {
    super.initState();
    _treeData = widget.provider.treeMap;
    _displayListItem = _treeData;
  }

  void _unfocus() {
    // text 不爲空和聚焦情況下才進行清除動作
    if (_textController.text.isNotEmpty && _focusNode.hasFocus) {
      _textController.clear();
      setState(() {
        // display item reset
        _displayListItem = _treeData;
      });
    }
    return;
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        focusNode: _focusNode,
        controller: _textController,
        decoration: searchInputDecoration.copyWith(
          hintStyle: kInputTextStyle,
          suffixIcon: GestureDetector(
            child: Icon(Icons.cancel),
            onTap: () => _unfocus(),
          ),
        ),
        onChanged: (text) {
          text.toLowerCase();
          setState(() {
            // display new list item
            _displayListItem = _treeData.where((element) {
              var title = element.folderName.toLowerCase();
              return title.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  Widget _listItem(int index, BuildContext context) {
    return LeafCard(
      data: _displayListItem[index],
      press: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(
            // 傳進當前 leafcard 的 treedata[index] 給 detail page
            data: _displayListItem[index],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 在 android 機上, 用於判斷 keyboard 彈出并且關閉
        // 更完善方法參考 https://segmentfault.com/a/1190000022495736
        if (_focusNode.hasFocus && Device.isAndroid) {
          _focusNode.unfocus();
        }
      },
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => widget.provider.fetchTreeData(),
          child: ListView.builder(
            itemCount: _displayListItem.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return index == 0 ? _searchBar() : _listItem(index - 1, context);
            },
          ),
        ),
      ),
    );
  }
}
