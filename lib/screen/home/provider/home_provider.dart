import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/dio_options.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/locale_utils.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/models/tree_info.dart' as info;

enum Status { Uninitialized, Loaded, Refresh, Error }

class HomeProvider extends ChangeNotifier {
  Status status = Status.Uninitialized;

  int _currentPage = 1;
  bool _nextPage = true;

  List<info.Result> _list = [];

  List<info.Result> get list => _list;
  bool get haveNext => _nextPage;

  Dio dio = Dio(stringOptions);

  /// 首次加載
  Future<bool> fetchData() async {
    final path = '${RestApi.localUrl}/flora/info/';

    try {
      final response = await dio.get(path,
          options: Options(headers: {
            HttpHeaders.acceptLanguageHeader: LocaleUtils.getLocale
          }));

      final data = info.treeInfoFromJson(response.data);

      if (data.next == null) _nextPage = false;

      _list = data.results;

      if (status != Status.Loaded) {
        status = Status.Loaded;
        notifyListeners();
      }

      return true;
    } catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(message: error.messge, type: Type.Warning);

      if (status == Status.Uninitialized) {
        status = Status.Error;
        notifyListeners();
      }

      return false;
    }
  }

  /// 下拉加載更多資料
  Future<bool> loadMore() async {
    if (!_nextPage) {
      // 已經沒東西可以給了, 直接返回, 什麼都不做
      return true;
    }

    _currentPage += 1; // 每次分頁增加
    print(_currentPage);

    final path = '${RestApi.localUrl}/flora/info/?page=$_currentPage';

    print(path);

    try {
      final response = await dio.get(path);

      final data = info.treeInfoFromJson(response.data);

      // 如果伺服器傳回沒有下一頁
      if (data.next == null) _nextPage = false;

      // 將新 data 加入現有的 list
      _list.addAll(data.results);
      notifyListeners();

      return true;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(message: error.messge, type: Type.WTF);

      // 既然失敗了就沒有下一頁了
      _nextPage = false;

      return false;
    }
  }

  /// 上拉刷新
  Future<bool> refresh() async {
    status = Status.Refresh;
    _currentPage = 1; // 重置頁數
    _nextPage = true; // 重置下頁可能
    _list.clear();
    return fetchData();
  }
}
