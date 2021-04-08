import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../provider/tree_data_provider.dart';
import 'tree_list.dart';

class TreeListBuild extends StatefulWidget {
  final BuildContext context;
  final TreeDataProvider provider;

  const TreeListBuild({Key key, this.provider, this.context}) : super(key: key);

  @override
  _TreeListBuildState createState() => _TreeListBuildState();
}

class _TreeListBuildState extends State<TreeListBuild> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<TreeData> _treeData = [];
  // for search list display
  List<TreeData> _displayListItem = [];

  bool _clearButton = false;

  @override
  void dispose() {
    super.dispose();
    // 銷毀listener防止內存泄漏
    _focusNode?.dispose();
    _textController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _treeData = widget.provider.treeMap;
    _displayListItem = _treeData;
    _textController.addListener(() {
      setState(() {
        // text length > 0 then true
        _clearButton = _textController.text.length > 0;
      });
    });
  }

  void _reset() {
    // text 不爲空進行清除動作
    if (_textController.text.isNotEmpty) {
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
          suffixIcon: (!_clearButton)
              ? null
              : GestureDetector(
                  child: Icon(Icons.cancel),
                  onTap: () => _reset(),
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
    return TreeList(
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
              return AnimationConfiguration.staggeredList(
                position: index,
                child: FadeInAnimation(
                  child:
                      index == 0 ? _searchBar() : _listItem(index - 1, context),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
