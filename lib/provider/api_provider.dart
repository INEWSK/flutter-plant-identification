import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/constants/constants.dart';
import 'package:flutter_hotelapp/common/constants/dio_options.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/local_notification.dart';
import 'package:flutter_hotelapp/common/utils/locale_utils.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart' as tree;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';

enum Result { ERROR, SUCCESS }
enum Choice { Local, GoogleDrive }

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
        // 目前儲存的locale和新抓得locale不相同(即用戶轉換過語言)
        if (_listData.isEmpty || _locale != locale) {
          //清空 list
          _listData.clear();
          await _fetchTreeData();
        }

        // 將 ai 傳回的 response 根據名字查找是否有對應名字的資料
        final String keyword = aiResult.toLowerCase();
        final data = await _matchTreeData(keyword);

        result['data'] = data;
        result['success'] = true;
        result['result'] = aiResult;

        isLoading = false;
        notifyListeners();
      });

      return result;
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(messageType: Type.Error, message: error.messge);

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
    // 儲存當前語言, 用作下次對比 data 是否對應目前手機語言
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
      LoggerUtils.show(messageType: Type.Warning, message: error.messge);
      return false;
    }
  }

  Future<tree.Result> _matchTreeData(String keyword) async {
    //根據 keyword 嘗試查找單個符合的元素
    //如果有多個則拋出 error
    //如果沒有則返回 null
    //因爲不是使用 sql 不清楚往後數據量大會否對效能造成影響
    _data = _listData.singleWhere((element) {
      var title = element.folderName.toLowerCase();
      return title.contains(keyword);
    }, orElse: () => null);

    debugPrint(_data != null ? _data.commonName : '沒有資料');

    return _data;
  }

  Future requestRetrain({Choice choice = Choice.Local}) async {
    /// 目前伺服器思路只要沒有給 taskid 就會當成 retraining 請求
    /// 反之有 taskid 則忽視 choice, 返回 task 的 status
    final formData = FormData.fromMap({
      'choice': choice == Choice.Local ? 'none' : 'google_drive',
      'task_id': 'none',
    });

    try {
      final url = '/flora/tree-ai-retrain/';

      final response = await dio.post(url, data: formData);

      final Map<String, dynamic> jsonResponse = response.data;

      if (response.statusCode == 202) {
        if (jsonResponse.containsKey('Task Id')) {
          String taskId = jsonResponse['Task Id'];

          // task id 持久化, 用於檢測是否有進行中的任務
          var box = Hive.box(Constant.box);
          await box.put(Constant.taskId, taskId);
          // task id log output
          LoggerUtils.show(message: 'Task ID: $taskId', messageType: Type.Info);
        } else {
          // 是 202 status (retraining accept) 但又沒有 taskid?
          // 讓我瞧瞧是什麼東西
          print(jsonResponse);
        }
        _backgroundService(true);
        _training = true;
        notifyListeners();
      }
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(message: error.messge, messageType: Type.WTF);
    }
  }

  /// Task Status: false, Updated, failed
  /// 詢問伺服器當前執行的 task id 任務進度
  Future<String> browseTaskStatus() async {
    var box = Hive.box(Constant.box);
    final String taskId = box.get(Constant.taskId);

    //一般作用於在 model retraining 的時候(意外)退出了 app
    // 當再次進入 app 時候檢查 box 是否有儲存 taskId
    //如有則會再呼叫一次 method 並將 training set true
    //以令設置在 profile screen 的 timer 重複呼叫該method 檢查 task status
    if (!_training) {
      _training = true;
    }

    final formData = FormData.fromMap({
      'choice': 'none',
      'task_id': taskId,
    });

    try {
      final response =
          await dio.post('/flora/tree-ai-retrain/', data: formData);

      final Map<String, dynamic> jsonResponse = response.data;

      // false (processing)
      if (response.statusCode == 208) {
        if (jsonResponse.containsKey('Task Status')) {
          bool taskStatus = jsonResponse['Task Status'];
          debugPrint('Task Status: ${taskStatus.toString()}');
          return '我在執行 method 檢查 Task Status \n伺服器結果爲 ${taskStatus.toString()}';
        }
      }

      // Updated or failed
      if (response.statusCode == 200) {
        if (jsonResponse.containsKey('Task Status')) {
          String taskStatus = jsonResponse['Task Status'];

          debugPrint('Task Status: ${taskStatus.toString()}');
          //如果 task 完成清空持久化 taskid
          await box.delete(Constant.taskId);

          _backgroundService(false);
          _training = false;
          notifyListeners();

          return '伺服器傳回 200 狀態, 結果爲 $taskStatus';
        }
      } else {
        //什麼?! 正常傳回200狀態彈沒有給task status
        //想想就不可能
        print(response.data);
      }
      return '不好意思, 發生爆炸了';
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      print(error.messge);
      return '不好意思, 發生爆炸了';
    }
  }

  ///Android 8.0以上軟件進入後台1分鐘後就會進入閒置狀態, 限制取用
  ///有機會被系統殺死APP釋放內存
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
