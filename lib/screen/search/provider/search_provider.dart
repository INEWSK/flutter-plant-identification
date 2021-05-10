import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/dio_options.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/hive_utils.dart';
import 'package:flutter_hotelapp/common/utils/locale_utils.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart' as tree;
import 'package:hive/hive.dart';

// hive = local database
enum Status { Uninitialized, Loading, Loaded, Error, Hive, Offline }

class SearchProvider extends ChangeNotifier {
  Status _status = Status.Uninitialized;

  int _currentPage = 1;
  bool _nextPage = true;
  bool _searchEnable = true;

  List<tree.Result> _data = [];
  List<tree.Result> _displayList = [];

  var hiveUtils = HiveUtils();
  // 儲存 local data 的箱子名
  final String boxName = 'searchPageDataBox';

  // dio baseoption preset
  Dio dio = Dio(stringOptions);

  //getter
  get displayList => _displayList;
  get status => _status;
  bool get enable => _searchEnable;
  bool get nextPage => _nextPage;

  void onQueryChanged(String query) async {
    //根據query查找data相應的字符再傳進display list
    _displayList = _data.where((element) {
      var title = element.folderName.toLowerCase();
      return title.contains(query);
    }).toList();

    notifyListeners();
  }

  void clearQuery() {
    // show all
    _displayList = _data;
    notifyListeners();
  }

  Future<bool> fetchApiData() async {
    // 防止初次進入 searchpage 已經在 loading 的時候
    // 再次通知 widget 進行更新導致重複構建頁面
    // 總之在 error page  才呼叫 loading widget
    if (_status == Status.Error) {
      _status = Status.Loading;
      notifyListeners();
    }

    final url = '/flora/tree/?page=$_currentPage';

    try {
      final response = await dio.get(url,
          options: Options(headers: {
            HttpHeaders.acceptLanguageHeader: LocaleUtils.getLocale
          }));

      final data = tree.treeDataFromJson(response.data);
      // 如果 api 沒有下一頁內容
      if (data.next == null) _nextPage = false;

      //清除現有的 data, *如有
      //用於 refresh method
      _data.clear();

      _data = data.results;
      _displayList = _data;

      var box = await Hive.openBox(boxName);
      await box.clear();
      // 把新抓到的 data 儲存到 hive local database
      await hiveUtils.addBoxes(_data, boxName);

      _status = Status.Loaded;
      // 通知 widget 更新
      notifyListeners();

      return true;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(messageType: Type.Warning, message: error.messge);

      // 如果在 loaded status 意味着 user 曾經成功加載過 api data
      // 直接 return 保持現有 data 狀態
      // 不需要加載 local database data 複寫
      if (_status != Status.Loaded) {
        // api unsuccess, try to loading local data
        try {
          bool exist = await hiveUtils.isExists(boxName: boxName);
          // 如果 local 有 data
          if (exist) {
            _data = await hiveUtils.getBoxes<tree.Result>(boxName);
            _displayList = _data;
            // local data status
            _status = Status.Hive;
            notifyListeners();
            // still need return false to notify screen show error widget
            // notification bar, toast etc.
            return false;
          }

          // 如果 local 也沒有 data 則顯示 error page 等待連接至網絡
          _status = Status.Error;
          notifyListeners();

          return false;
        } catch (e) {
          // 這裏是 hive 原地爆炸才會出現的錯誤
          LoggerUtils.show(message: e.toString(), messageType: Type.Warning);

          if (_status != Status.Loaded) {
            _status = Status.Error;
            notifyListeners();
          }

          return false;
        }
      } else {
        print('我直接返回 false 了, 因爲目前是 API data Loaded');
        return false;
      }
    }
  }

  /// 下拉加載更多資料
  Future<bool> loadMore() async {
    // 爲什麼不在UI直接禁止 onload
    // 因爲想保留footer
    if (!_nextPage) {
      // 已經沒東西可以給了, 直接返回, 什麼都不做
      return true;
    }

    //加載時禁止搜索欄
    isEnableSearchBar(false);

    _currentPage += 1; // 目前資料頁數 ++

    final path = '/flora/tree/?page=$_currentPage';

    try {
      final response = await dio.get(path);

      final data = tree.treeDataFromJson(response.data);

      // 如果伺服器傳回沒有下一頁資料
      if (data.next == null) _nextPage = false;

      // 將新 data 加入現有的 list
      _data.addAll(data.results);
      _displayList = _data;

      //清空已儲存在本地的 data
      var box = await Hive.openBox(boxName);
      await box.clear();

      // 把新抓到的 data 儲存到 hive
      await hiveUtils.addBoxes(_data, boxName);

      _searchEnable = true;
      notifyListeners();

      return true;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(message: error.messge, messageType: Type.WTF);

      // 既然失敗了就沒有下一頁了
      _nextPage = false;
      _searchEnable = true;
      notifyListeners();

      return false;
    }
  }

  /// 上拉刷新
  Future<bool> refresh() async {
    // 避免refresh期間 list未加載完成時用戶執行搜索操作
    isEnableSearchBar(false);

    _currentPage = 1; // 重置頁數
    _nextPage = true; // 重置下頁可能

    return fetchApiData().then((success) {
      isEnableSearchBar(true);
      return success;
    });
  }

  isEnableSearchBar(bool isEnable) {
    _searchEnable = isEnable;
    notifyListeners();
  }
}
