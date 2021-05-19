import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/dio_options.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/hive_utils.dart';
import 'package:flutter_hotelapp/common/utils/locale_utils.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/models/tree_info.dart' as treeInfo;
import 'package:hive/hive.dart';

enum Status { Uninitialized, Network, Refresh, Error, Hive, Offline }

class HomeProvider extends ChangeNotifier {
  Status status = Status.Uninitialized;

  int _currentPage = 1;
  bool _nextPage = true;

  List<treeInfo.Result> _list = [];

  var hiveUtils = HiveUtils();
  // 儲存於本地 hive 箱子的名字
  final String boxName = 'homeCardInfoBox';

  //dio baseoption preset
  Dio dio = Dio(stringOptions);

  //getter
  List<treeInfo.Result> get list => _list;
  bool get haveNext => _nextPage;

  Future<bool> fetchApiData() async {
    final path = '/flora/info/';

    try {
      final response = await dio.get(
        path,
        options: Options(
            headers: {HttpHeaders.acceptLanguageHeader: LocaleUtils.getLocale}),
      );

      final data = treeInfo.treeInfoFromJson(response.data);

      if (data.next == null) _nextPage = false;

      _list = data.results;

      //清空已儲存在本地的 data 並塞新的 data 進去
      var box = await Hive.openBox(boxName);
      await box.clear();

      // 把新抓到的 data 儲存到 hive
      await hiveUtils.addBoxes(_list, boxName);

      if (status != Status.Network) {
        status = Status.Network;
        notifyListeners();
      }

      return true;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(message: error.messge, messageType: Type.Warning);

      try {
        bool exist = await hiveUtils.isExists(boxName: boxName);
        // 如果 local database 有儲存之前抓過的 data
        if (exist) {
          // 寫入 list
          _list = await hiveUtils.getBoxes<treeInfo.Result>(boxName);

          if (status != Status.Network) {
            // 通知 widget 處於本地數據庫模式, refresh 之類功能不可使用
            status = Status.Hive;
            notifyListeners();
          }

          // 雖然有 data 提供但還是要返回 false 通知 ui 顯示對應 widget
          return false;
        }

        if (status == Status.Uninitialized) {
          status = Status.Error;
          notifyListeners();
        }

        return false;
      } catch (e) {
        // 這裏是 hive 原地爆炸才會出現的錯誤
        LoggerUtils.show(message: e.toString(), messageType: Type.Warning);

        if (status == Status.Uninitialized) {
          status = Status.Error;
          notifyListeners();
        }

        return false;
      }
    }
  }

  /// 下拉加載更多資料
  Future<bool> loadMore() async {
    // 已經沒東西可以給了, 直接返回, 什麼都不做
    if (!_nextPage) return true;

    // _currentPage += 1; // 每次分頁增加
    final Map<String, dynamic> params = {"page": _currentPage += 1};

    final path = '/flora/info/';

    try {
      final response = await dio.get(
        path,
        queryParameters: params,
        options: Options(
          headers: {HttpHeaders.acceptLanguageHeader: LocaleUtils.getLocale},
        ),
      );
      final data = treeInfo.treeInfoFromJson(response.data);

      // 如果伺服器傳回沒有下一頁
      if (data.next == null) _nextPage = false;

      // 將新 data 加入現有的 list
      _list.addAll(data.results);

      //清空已儲存在本地的 data
      var box = await Hive.openBox(boxName);
      await box.clear();

      // 把新抓到的 data 儲存到 hive
      await hiveUtils.addBoxes(_list, boxName);
      notifyListeners();

      return true;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(message: error.messge, messageType: Type.WTF);

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
    return fetchApiData();
  }
}
