import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';

enum Status { Uninitialized, Loading, Loaded, Error }
enum Language { HK, EN, CN }

class SearchProvider extends ChangeNotifier {
  Status _status = Status.Uninitialized;
  Language _language = Language.HK;

  List<TreeData> _data = [];
  List<TreeData> _displayList = [];

  get status => _status;
  get displayList => _displayList;

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
    // dio baseoption preset
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: 5000, //10s
        receiveTimeout: 10000,
        headers: {
          HttpHeaders.acceptLanguageHeader:
              _language == Language.HK ? 'zh-HK' : 'en-US',
        },
        // contentType: Headers.jsonContentType,
        // 要求 response 傳回字符串而不要轉化爲 list
        responseType: ResponseType.plain,
      ),
    );

    final url = '${RestApi.localUrl}/flora/tree/';

    // 防止初次刷新時候再次通知widget進行更新導致警告
    if (_status == Status.Error) {
      _status = Status.Loading;
      notifyListeners();
    }

    // UI result
    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknow error',
    };

    try {
      final response = await dio.get(url);

      result['success'] = true;
      result['message'] = 'Data Loaded';

      final data = treeDataFromJson(response.data);

      log('Tree Data Reloaded');
      _data = data;
      _displayList = _data;

      _status = Status.Loaded;
      // 通知所有 listener 更新
      notifyListeners();

      return result;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      //輸出錯誤到控制台
      log('TreeDataProvider -> ${error.messge}');

      /// 返回信息 UI 通知刷新失敗
      result['message'] = error.messge;

      _status = Status.Error;
      notifyListeners();

      return result;
    }
  }
}
