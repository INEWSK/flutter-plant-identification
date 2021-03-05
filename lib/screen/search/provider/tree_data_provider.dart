import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';

enum Status { Uninitialized, Loading, Loaded, Error }

class TreeDataProvider extends ChangeNotifier {
  Status _status = Status.Uninitialized;
  List<TreeData> _list = [];

  get status => _status;
  get treeData => _list;

  // dio baseoption preset
  Dio dio = Dio(
    BaseOptions(
      connectTimeout: 10000,
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

  /// 默認請求地址
  final String baseUrl = 'https://florabackend.azurewebsites.net';
  // 本地測試請求地址
  final String localUrl = 'http://10.0.2.2:8000';

  //使用 dio 從後端獲取花草的數據
  //TODO: network connection detect.
  Future<void> fetchTreeData() async {
    // loading data
    _status = Status.Loading;
    notifyListeners();

    final url = "$localUrl/flora/tree/";
    try {
      final response = await dio.get(url);

      // 這是呼叫 method 先 decode json 后再轉換為 list<model>
      var data = treeResponseFromJson(response.data);

      //data loaded;
      _status = Status.Loaded;
      _list = data;

      notifyListeners();
    } on DioError catch (e) {
      //輸出錯誤到控制台
      log('TreeDataProvider -> ${e.message}');
      //將錯誤輸入到包裝好的dioException簡化結果再輸出
      final error = DioExceptions.fromDioError(e);
      //返回toast到前端, 這裏之後修改放到UI層面
      Toast.show(error.messge + '.\nPlease try again later');

      //data loaded and it's error status;
      _status = Status.Error;

      notifyListeners();
    }
  }

  //將map type 轉成 list type
  List<TreeData> treeResponseFromJson(String str) =>
      List<TreeData>.from(json.decode(str).map((x) => TreeData.fromJson(x)));
}
