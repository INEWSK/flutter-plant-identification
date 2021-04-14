import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/local_notification.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum Language { HK, EN, CN }
enum Result { ERROR, SUCCESS }

class ApiProvider extends ChangeNotifier {
  final key = UniqueKey();

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Language _language = Language.EN;
  bool _training = false;

  get train => _training;

  Dio dio = Dio(BaseOptions(
    baseUrl: RestApi.localUrl,
    connectTimeout: 5000, // 5s
    receiveTimeout: 10000, // 10s
    // contentType 爲 json 則 response 自動轉化爲 json 對象
    contentType: Headers.jsonContentType,
    // responseType: ResponseType.plain,
  ));

  void upload(File file) async {
    // simple loading toast when waiting server response result
    _loadingToast();

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

      await dio
          .post(url,
              data: data,
              options: Options(headers: {
                HttpHeaders.acceptLanguageHeader:
                    _language == Language.HK ? 'zh-HK' : 'en-US'
              }))
          .then((response) {
        final result = response.toString();
        BotToast.remove(key);

        _resultToast(result, Result.SUCCESS);
      });
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      print('API CALL ERROR: ${error.messge}');
      BotToast.remove(key);
      _resultToast(error.messge, Result.ERROR);
    }
  }

  void _loadingToast() {
    BotToast.showWidget(
      // 賦予唯一key用於cancel
      key: key,
      toastBuilder: (void Function() cancelFunc) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              child: SpinKitChasingDots(
                size: 24,
                color: Colors.blue,
              ),
              width: 36,
              height: 36,
            ),
          ),
        ),
      ),
    );
  }

  void _resultToast(String result, Result type) {
    BotToast.showNotification(
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: IconButton(
            icon: type == Result.SUCCESS
                ? Icon(Ionicons.ios_rose, color: Colors.redAccent)
                : Icon(FontAwesome.times, color: Colors.redAccent),
            onPressed: cancel,
          )),
      title: (_) => Text(
        result,
        style: kBodyTextStyle,
      ),
      duration: Duration(seconds: 5),
    );
  }

  Future<String> requestRetrain() async {
    if (_training) {
      return 'Processing';
    }

    backgroundService(true);

    _training = true;
    notifyListeners();

    print('request AI retraining method');

    final result =
        await Future.delayed(const Duration(seconds: 10), () => 'AI訓練完畢');

    print(result);

    backgroundService(false);

    _training = false;
    notifyListeners();
    return result;
  }

  //這種東西估計也沒什麼用
  //A機8.0以上軟件進入後台1分鐘後就會進入閒置狀態, 限制取用
  //有機會被系統殺死APP釋放內存
  //自求平安
  void backgroundService(bool on) async {
    if (Device.isAndroid) {
      var methodChannel = MethodChannel("com.example.flutter_hotelapp");
      if (on) {
        String data = await methodChannel.invokeMethod("startService");
        print("Service Status: $data");
      } else {
        String data = await methodChannel.invokeMethod("stopService");

        LocalNotification.show(
          id: 0,
          title: '伺服器 AI 模型訓練',
          body: '伺服器返回狀態',
        );

        print("Service Status: $data");
      }
    }
    // ios 只返回 notification
    if (Device.isIOS) {
      if (!on) {
        LocalNotification.show(
          id: 0,
          title: '伺服器 AI 模型訓練',
          body: '伺服器完成 AI 圖形訓練',
        );
      }
    }
  }
}
