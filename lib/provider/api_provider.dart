import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/locale_utils.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart' as tree;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum Language { HK, EN, CN }
enum Result { ERROR, SUCCESS }

class ApiProvider extends ChangeNotifier {
  final key = UniqueKey();

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  String _locale;
  bool isLoading = false;
  List<tree.Result> _listData = [];
  tree.Result data;

  Dio dio = Dio(BaseOptions(
    baseUrl: RestApi.localUrl,
    connectTimeout: 5000, // 5s
    receiveTimeout: 10000, // 10s
    responseType: ResponseType.json,
  ));

  Future<Map> upload(File file) async {
    //for UI result
    Map<String, dynamic> result = {
      'success': false,
      'result': 'Unknown',
      'data': tree.Result ?? null,
    };

    // fab loading effect
    isLoading = true;
    notifyListeners();

    // 取檔案路徑最後一個 '/' 餘後的內容作為檔案名字.
    final fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      )
    });

    try {
      final url = '/flora/tree-ai/';

      await dio.post(url, data: data).then((response) async {
        final aiResult = response.data.toString();

        final String locale = LocaleUtils.getLocale;
        // 如果 list 爲空, 或是當前儲存得語言和新抓得語言不相同(既用戶轉語言)
        if (_listData.isEmpty || _locale != locale) {
          //清空 list
          _listData.clear();
          await _fetchTreeData();
        }

        // 將 ai 傳回的 response 根據名字查找是否有對應名字的資料
        final keyword = aiResult.toLowerCase();
        final data = await _test(keyword);

        result['data'] = data;
        result['success'] = true;
        result['result'] = aiResult;

        isLoading = false;
        notifyListeners();
      });

      return result;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(type: Type.Error, message: error.messge);

      result['result'] = error.messge;

      isLoading = false;
      notifyListeners();

      return result;
    }
  }

  Future<bool> _fetchTreeData() async {
    LoggerUtils.show(message: 'TREE DATA 空, 從 API 抓取資料');

    final url = '/flora/tree/';

    final String locale = LocaleUtils.getLocale;
    // 儲存語言資料, 用作下次對比
    _locale = locale;

    try {
      final response = await dio.get(url,
          options: Options(responseType: ResponseType.plain, headers: {
            HttpHeaders.acceptLanguageHeader: locale == 'zh' ? 'zh-HK' : 'en-US'
          }));
      final data = tree.treeDataFromJson(response.data).results;

      _listData = data;

      return true;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      //輸出錯誤到控制台
      LoggerUtils.show(type: Type.Warning, message: error.messge);
      return false;
    }
  }

  Future<tree.Result> _test(String keyword) async {
    //根據 keyword 嘗試查找單個符合的元素
    //如果有多個則拋出 error
    //如果沒有則返回 null
    //因爲不是使用database, 不清楚往後數據量大會否對效能造成影響
    data = _listData.singleWhere((element) {
      var title = element.folderName.toLowerCase();
      return title.contains(keyword);
    }, orElse: () => null);

    debugPrint(data != null ? data.commonName : '沒有資料');

    return data;
  }
}
