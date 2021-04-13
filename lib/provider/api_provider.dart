import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum Language { HK, EN, CN }

class ApiProvider extends ChangeNotifier {
  final key = UniqueKey();

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

        _resultToast(result, false);
      });
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      print('API CALL ERROR: ${error.messge}');
      BotToast.remove(key);
      _resultToast(error.messge, true);
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

  void _resultToast(String result, bool isError) {
    BotToast.showNotification(
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: IconButton(
            icon: isError == false
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
        await Future.delayed(const Duration(seconds: 20), () => 'AI訓練完畢');

    print(result);

    backgroundService(false);

    _training = false;
    notifyListeners();
    return result;
  }

  void backgroundService(bool on) async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("com.example.flutter_hotelapp");
      if (on) {
        String data = await methodChannel.invokeMethod("startService");
        print("data: $data");
      } else {
        String data = await methodChannel.invokeMethod("stopService");
        print("data: $data");
      }
    }
  }
}
