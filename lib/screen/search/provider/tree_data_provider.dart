import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';

enum Status { Uninitialized, Loading, Loaded, Error }

class TreeDataProvider extends ChangeNotifier {
  Status _status = Status.Uninitialized;
  List<TreeData> _list = [];

  Status get status => _status;
  List<TreeData> get treeMap => _list;

  // dio baseoption preset
  Dio dio = Dio(
    BaseOptions(
      connectTimeout: 10000, //10s
      receiveTimeout: 100000,
      headers: {
        HttpHeaders.acceptHeader: "application/json",
        HttpHeaders.userAgentHeader: "",
        HttpHeaders.acceptLanguageHeader: 'en-US',
      },
      contentType: Headers.jsonContentType,
      responseType: ResponseType.plain,
    ),
  );

  //使用 dio 從後端獲取花草的數據
  Future<Map> fetchTreeData() async {
    final url = '${RestApi.localUrl}/flora/tree/';
    // retry fetch data
    if (_status == Status.Error) {
      // 錯誤頁面下會重新顯示 shimmer effect 當重新加載時
      _status = Status.Loading;
      notifyListeners();
    }

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknow error',
    };

    try {
      final response = await dio.get(url);

      result['success'] = true;
      result['message'] = 'Data loaded';

      // 這是呼叫 method 先 decode json 后再轉換為 list<model>
      final data = List<TreeData>.from(
        json.decode(response.data).map(
              (x) => TreeData.fromJson(x),
            ),
      );

      if (_list != data) {
        //data loaded;
        log('tree data loaded');
        _list = data;
      }

      _status = Status.Loaded;
      // 通知所有 listener 更新
      notifyListeners();

      return result;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      //輸出錯誤到控制台
      log('TreeDataProvider -> ${error.messge}');

      /// 直接返回信息 UI 通知刷新失敗
      result['message'] = error.messge;

      _status = Status.Error;
      notifyListeners();

      return result;
    }
  }
}
