import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/dio_options.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/locale_utils.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart' as tree;

enum Language { HK, EN, CN }
enum Status { Uninitialized, Loading, Loaded, Error }

class SearchProvider extends ChangeNotifier {
  Status _status = Status.Uninitialized;

  int _currentPage = 1;
  bool _nextPage = true;
  bool _searchEnable = true;

  List<tree.Result> _data = [];
  List<tree.Result> _displayList = [];

  // dio baseoption preset
  Dio dio = Dio(stringOptions);

  get displayList => _displayList;
  get status => _status;
  bool get enable => _searchEnable;

  void onQueryChanged(String query) async {
    //根據query查找data相應的字符再傳進display list
    _displayList = _data.where((element) {
      var title = element.folderName.toLowerCase();
      return title.contains(query);
    }).toList();

    notifyListeners();
  }

  void clear() {
    // show all
    _displayList = _data;
    notifyListeners();
  }

  Future<bool> fetchData() async {
    // 防止初次刷新時候再次通知widget進行更新導致警告
    if (_status == Status.Error) {
      _status = Status.Loading;
      notifyListeners();
    }

    if (_status == Status.Loaded) {
      _searchEnable = false;
      notifyListeners();
    }

    final url = '/flora/tree/?page=$_currentPage';

    try {
      final response = await dio.get(url,
          options: Options(headers: {
            HttpHeaders.acceptLanguageHeader: LocaleUtils.getLocale
          }));

      final data = tree.treeDataFromJson(response.data);

      if (data.next == null) _nextPage = false;

      _data = data.results;
      _displayList = _data;

      print('Data Loaded');
      _status = Status.Loaded;
      _searchEnable = true;
      // 通知 widget 更新
      notifyListeners();

      return true;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      //輸出錯誤到控制台
      LoggerUtils.show(type: Type.Warning, message: error.messge);

      //已經加載完成情況下不返回 error status 跳 error page
      if (_status != Status.Loaded) {
        _status = Status.Error;
      }

      _searchEnable = true;
      notifyListeners();

      return false;
    }
  }

  /// 下拉加載更多資料
  Future<bool> loadMore() async {
    if (!_nextPage) {
      // 已經沒東西可以給了, 直接返回, 什麼都不做
      return true;
    }

    //更新時禁止搜索欄
    _searchEnable = false;
    notifyListeners();

    _currentPage += 1; // 每次分頁增加
    print(_currentPage);

    final path = '/flora/tree/?page=$_currentPage';

    print(path);

    try {
      final response = await dio.get(path);

      final data = tree.treeDataFromJson(response.data);

      // 如果伺服器傳回沒有下一頁
      if (data.next == null) _nextPage = false;

      // 將新 data 加入現有的 list
      _data.addAll(data.results);
      _displayList = _data;
      _searchEnable = true;
      notifyListeners();

      return true;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(message: error.messge, type: Type.WTF);

      // 既然失敗了就沒有下一頁了
      _nextPage = false;
      _searchEnable = true;
      notifyListeners();

      return false;
    }
  }

  /// 上拉刷新
  Future<bool> refresh() async {
    _currentPage = 1; // 重置頁數
    _nextPage = true; // 重置下頁可能
    _data.clear();
    return fetchData();
  }
}
