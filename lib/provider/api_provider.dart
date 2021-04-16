import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum Language { HK, EN, CN }
enum Result { ERROR, SUCCESS }

class ApiProvider extends ChangeNotifier {
  final key = UniqueKey();

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Language _language = Language.EN;

  Dio dio = Dio(BaseOptions(
    baseUrl: RestApi.localUrl,
    connectTimeout: 5000, // 5s
    receiveTimeout: 10000, // 10s
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

      await dio.post(url, data: data).then((response) {
        final result = response.toString();
        debugPrint(result);
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
}
