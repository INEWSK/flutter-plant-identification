import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/constants/dio_options.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/local_notification.dart';
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
  tree.Result _data;
  bool _training = false;

  get data => _data;
  get training => _training;

  Dio dio = Dio(jsonOptions);

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
        // 如果 list 爲空 或
        // 是當前var儲存的locale和新抓得locale不相同(即用戶轉語言)
        if (_listData.isEmpty || _locale != locale) {
          //清空 list
          _listData.clear();
          await _fetchTreeData();
        }

        // 將 ai 傳回的 response 根據名字查找是否有對應名字的資料
        final String keyword = aiResult.toLowerCase();
        final data = await _searchTreeData(keyword);

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
            HttpHeaders.acceptLanguageHeader: LocaleUtils.getLocale
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

  Future<tree.Result> _searchTreeData(String keyword) async {
    //根據 keyword 嘗試查找單個符合的元素
    //如果有多個則拋出 error
    //如果沒有則返回 null
    //因爲不是使用database, 不清楚往後數據量大會否對效能造成影響
    _data = _listData.singleWhere((element) {
      var title = element.folderName.toLowerCase();
      return title.contains(keyword);
    }, orElse: () => null);

    debugPrint(_data != null ? _data.commonName : '沒有資料');

    return _data;
  }

  Future<String> requestRetrain() async {
    if (_training) {
      return 'Processing';
    }

    _backgroundService(true);

    _training = true;
    notifyListeners();

    final result =
        await Future.delayed(const Duration(seconds: 10), () => 'AI訓練完畢');
    debugPrint(result);

    _backgroundService(false);

    _training = false;
    notifyListeners();
    return result;
  }

  //A機8.0以上軟件進入後台1分鐘後就會進入閒置狀態, 限制取用
  //有機會被系統殺死APP釋放內存
  //自求平安
  Future<void> _backgroundService(bool on) async {
    if (Device.isAndroid) {
      var methodChannel = MethodChannel("com.example.flutter_hotelapp");
      if (on) {
        String data = await methodChannel.invokeMethod("startService");
        debugPrint("Service Status: $data");
      } else {
        String data = await methodChannel.invokeMethod("stopService");

        LocalNotification.show(
          id: 0,
          title: '伺服器 AI 模型訓練',
          body: '伺服器已完成圖形訓練',
        );

        debugPrint("Service Status: $data");
      }
    }
    // ios 只返回 notification
    if (Device.isIOS) {
      if (!on) {
        LocalNotification.show(
          id: 0,
          title: '伺服器 AI 模型訓練',
          body: '伺服器已完成圖形訓練',
        );
      }
    }
  }
}
