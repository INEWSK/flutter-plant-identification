import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';

enum Language { HK, EN, CN }
enum Status { Uninitialized, Loading, Loaded, Error }

class SearchProvider extends ChangeNotifier {
  Status _status = Status.Uninitialized;
  Language _language = Language.HK;

  List<TreeData> _data = [];
  List<TreeData> _displayList = [];
  TreeData _testData;

  // dio baseoption preset
  Dio dio = Dio(
    BaseOptions(
      connectTimeout: 10000, //10s
      receiveTimeout: 5000,
      responseType: ResponseType.plain,
    ),
  );

  get displayList => _displayList;
  get status => _status;

  void onQueryChanged(String query) async {
    //根據query查找data相應的字符再傳進display list
    _displayList = _data.where((element) {
      var title = element.folderName.toLowerCase();
      return title.contains(query);
    }).toList();

    notifyListeners();
  }

  void clear() {
    // 將所有 data 再傳進 display list
    _displayList = _data;
    notifyListeners();
  }

  Future<Map> fetchData() async {
    // 防止初次刷新時候再次通知widget進行更新導致警告
    if (_status == Status.Error) {
      _status = Status.Loading;
      notifyListeners();
    }

    // for UI result
    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknow error',
    };

    final url = '${RestApi.localUrl}/flora/tree/';

    try {
      final response = await dio.get(url,
          options: Options(headers: {
            HttpHeaders.acceptLanguageHeader:
                _language == Language.HK ? 'zh-HK' : 'en-US'
          }));

      result['success'] = true;
      result['message'] = 'Loaded';

      final data = treeDataFromJson(response.data);

      _data = data;
      _displayList = _data;

      debugPrint('data loaded');
      _status = Status.Loaded;
      // 通知 widget 更新
      notifyListeners();

      return result;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      //輸出錯誤到控制台
      LoggerUtils.show(type: Type.Warning, message: error.messge);

      /// 返回錯誤信息給 UI
      result['message'] = error.messge;

      _status = Status.Error;
      notifyListeners();

      return result;
    }
  }

  void test(String keyword) async {
    //根據 keyword 嘗試查找單個符合的元素
    //如果有多個則拋出 error
    //如果沒有則返回 null
    //因爲不是使用database, 不清楚往後數據量大會否對效能造成影響
    _testData = _data.singleWhere((element) {
      var title = element.folderName.toLowerCase();
      return title.contains(keyword);
    }, orElse: () => null);

    debugPrint(_testData != null ? _testData.commonName : '沒有資料');
  }
}
