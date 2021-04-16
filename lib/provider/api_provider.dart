import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum Language { HK, EN, CN }
enum Result { ERROR, SUCCESS }

class ApiProvider extends ChangeNotifier {
  final key = UniqueKey();

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool isLoading = false;
  Language _language = Language.EN;
  List<TreeData> _listData = [];
  TreeData data;

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
      'data': TreeData ?? null,
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
        final responseData = response.data.toString();

        if (_listData.isEmpty) {
          await _fetchTreeData();
        }
        // 將 ai 傳回的 response 根據名字查找是否有對應名字的資料
        final keyword = responseData.toLowerCase();
        final data = await _test(keyword);

        result['success'] = true;
        result['result'] = responseData;
        result['data'] = data;

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

  Future<void> _fetchTreeData() async {
    print('tree data 爲空, 開始執行 fetchTreeData');

    final url = '/flora/tree/';
    try {
      final response = await dio.get(url,
          options: Options(responseType: ResponseType.plain, headers: {
            HttpHeaders.acceptLanguageHeader:
                _language == Language.HK ? 'zh-HK' : 'en-US'
          }));
      final data = treeDataFromJson(response.data);
      _listData = data;
      print('data 加載完成');
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      //輸出錯誤到控制台
      LoggerUtils.show(type: Type.Warning, message: error.messge);
    }
  }

  Future<TreeData> _test(String keyword) async {
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
