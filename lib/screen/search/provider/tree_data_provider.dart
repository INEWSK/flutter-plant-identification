import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_hotelapp/models/tree_data_image.dart';

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

  /// 默認請求地址
  final String baseUrl = 'https://florabackend.azurewebsites.net';
  // 本地測試請求地址
  final String localUrl = 'http://10.0.2.2:8000';
  // vtc 內聯網
  final String vtcUrl = '192.168.20.81:80/api';

  //使用 dio 從後端獲取花草的數據
  fetchTreeData() async {
    // retry fetch data
    if (_status == Status.Error) {
      // 錯誤頁面下會重新顯示 shimmer effect 當重新加載時
      _status = Status.Loading;
      notifyListeners();
    }

    final url = "$localUrl/flora/tree";

    try {
      final response = await dio.get(url);

      // 這是呼叫 method 先 decode json 后再轉換為 list<model>
      var data = List<TreeData>.from(
        json.decode(response.data).map(
              (x) => TreeData.fromJson(x),
            ),
      );

      //data loaded;
      log('tree data loaded');
      _list = data;

      _status = Status.Loaded;
      notifyListeners();
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      //輸出錯誤到控制台
      log('TreeDataProvider -> ${error.messge}');
      //返回toast到前端, 這裏之後修改放到UI層面
      Toast.show(error.messge + '.\nPlease try again later');

      _status = Status.Error;
      notifyListeners();
    }
  }

  // fetchImage() async {
  //   final imgUrl = '$localUrl/flora/tree-image/';

  //   try {
  //     final response = await dio.get(imgUrl);

  //     var data = List<TreeDataImage>.from(
  //       json.decode(response.data).map(
  //             (x) => TreeDataImage.fromJson(x),
  //           ),
  //     );

  //     _listImg = data;

  //     //data loaded;
  //     log('image data loaded');
  //     notifyListeners();

  //     // _listImg = data;
  //   } on DioError catch (e) {
  //     final error = DioExceptions.fromDioError(e);
  //     //輸出錯誤到控制台
  //     log('TreeImage -> ${error.messge}');
  //     //返回toast到前端, 這裏之後修改放到UI層面
  //     Toast.show(error.messge + '.\nImage load failed');
  //   }
  // }
}
