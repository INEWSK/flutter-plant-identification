import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';

class TreeDataProvider extends ChangeNotifier {
  //TODO: network connection detect.
  Future<void> fetchTreeData() async {
    try {
      var dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/flora/tree",
        connectTimeout: 10000, //10s
        receiveTimeout: 100000,
        headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.userAgentHeader: "",
          HttpHeaders.acceptLanguageHeader: 'en-US',
        },
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ));

      Response response;

      response = await dio.get("/");

      // 這是呼叫 method 先 decode json 后再轉換為 list<model>
      var data = treeResponseFromJson(response.data);

      return data;
    } on DioError catch (e) {
      //輸出錯誤到控制台
      log('TreeDataProvider -> ${e.message}');
      //返回toast到前端
      final error = DioExceptions.fromDioError(e);
      Toast.show(error.messge);
    }
  }

  //這個是將map type 轉成 list type 用於lisview
  List<TreeData> treeResponseFromJson(String str) =>
      List<TreeData>.from(json.decode(str).map((x) => TreeData.fromJson(x)));
}
