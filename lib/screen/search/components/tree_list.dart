import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../provider/search_provider.dart';
import 'tree_item.dart';

class TreeList extends StatefulWidget {
  @override
  _TreeListState createState() => _TreeListState();
}

class _TreeListState extends State<TreeList> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  bool _clearButton = false;

  @override
  void dispose() {
    super.dispose();
    // 銷毀listener
    _focusNode?.dispose();
    _textController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _treeData = widget.provider.treeList;
    // _displayListItem = _treeData;
    _textController.addListener(() {
      setState(() {
        // text length > 0 then true
        _clearButton = _textController.text.length > 0;
      });
    });
  }

  void _reset(SearchProvider model) {
    // text 不爲空進行清除動作
    if (_textController.text.isNotEmpty) {
      _textController.clear();
      model.clear();
      return;
    }
  }

  Widget _searchBar(SearchProvider model) {
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
                  onTap: () => _reset(model),
                ),
        ),
        onChanged: (query) => model.onQueryChanged(query),
      ),
    );
  }

  Widget _listItem(int index, BuildContext context, SearchProvider model) {
    return TreeItem(
      data: model.displayList[index],
      press: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(
            // 傳進當前 leafcard 的 treedata 給 detail page
            data: model.displayList[index],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, model, _) {
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
              onRefresh: () => model.fetchData(),
              child: ListView.builder(
                itemCount: model.displayList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: FadeInAnimation(
                      child: index == 0
                          ? _searchBar(model)
                          : _listItem(index - 1, context, model),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
