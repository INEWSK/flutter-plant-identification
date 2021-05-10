import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';
import 'package:provider/provider.dart';

import '../provider/search_provider.dart';
import 'tree_cell.dart';

class TreeList extends StatefulWidget {
  @override
  _TreeListState createState() => _TreeListState();
}

class _TreeListState extends State<TreeList> {
  final _textController = TextEditingController();
  final _refreshController = EasyRefreshController();
  final _focusNode = FocusNode();

  bool _clearButton = false;

  @override
  void dispose() {
    super.dispose();
    // 銷毀listener
    _focusNode?.dispose();
    _refreshController?.dispose();
    _textController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        // text length > 0 then true
        _clearButton = _textController.text.length > 0;
      });
    });
  }

  void _reset() async {
    // text 不爲空進行清除動作
    if (_textController.text.isNotEmpty) {
      _textController.clear();
      //讀取 provider 內資料, 直接返回 T,不需要去監聽變化
      context.read<SearchProvider>().clearQuery();
      return;
    }
  }

  Widget _searchBar() {
    return Consumer<SearchProvider>(
      builder: (_, search, __) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            enabled: search.enable,
            focusNode: _focusNode,
            controller: _textController,
            decoration: searchInputDecoration.copyWith(
              contentPadding: const EdgeInsets.all(16.0),
              hintText: AppLocalizations.of(context).search,
              hintStyle: kInputTextStyle,
              suffixIcon: (!_clearButton)
                  ? null
                  : GestureDetector(
                      child: Icon(Icons.cancel),
                      onTap: () => _reset(),
                    ),
            ),
            onChanged: (query) => search.onQueryChanged(query),
          ),
        );
      },
    );
  }

  Widget _listItem(int index, BuildContext context, SearchProvider model) {
    return TreeCell(
      data: model.displayList[index],
      press: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(
            // 傳進當前 leafcard 的 treedata 給 detail page
            data: model.displayList[index],
            type: DataType.Tree,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (_, model, __) {
        return GestureDetector(
          onTap: () {
            // 在 android 機上, 用於判斷 keyboard 彈出并且關閉
            // 更完善方法參考 https://segmentfault.com/a/1190000022495736
            if (_focusNode.hasFocus && Device.isAndroid) {
              _focusNode.unfocus();
            }
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _searchBar(),
                Expanded(
                  child: EasyRefresh.custom(
                    controller: _refreshController,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return _listItem(index, context, model);
                          },
                          childCount: model.displayList.length,
                        ),
                      ),
                    ],
                    onRefresh: () async => model.refresh().then((success) {
                      if (!success) {
                        Toast.error(title: '網絡電波不夠', subtitle: '原地爆炸');
                      }
                      _refreshController.resetLoadState();
                    }),
                    onLoad: model.status == Status.Hive
                        // local data base 沒有加載更多
                        ? null
                        : () async => await model.loadMore().then((success) {
                              if (!success)
                                Toast.error(
                                  icon: Icons.wifi_lock,
                                  title: '伺服器遇到神祕阻力',
                                  subtitle: '加載不可',
                                );
                              _refreshController.finishLoad();
                            }),
                    header: DeliveryHeader(enableHapticFeedback: true),
                    footer: ClassicalFooter(
                      loadText: AppLocalizations.of(context).loadMoreText,
                      loadingText: AppLocalizations.of(context).loadingText,
                      loadReadyText: AppLocalizations.of(context).loadReadyText,
                      loadedText: AppLocalizations.of(context).loadedText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
