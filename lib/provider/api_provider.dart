import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ApiProvider extends ChangeNotifier {
  final key = UniqueKey();

  Dio dio = Dio(BaseOptions(
    connectTimeout: 10000, // 10s
    receiveTimeout: 100000,
  ));

  final apiUrl = 'http://10.0.2.2:80/flora/tree-ai/';
  // vtc network
  final vtcUrl = '192.168.20.81:80/api';

  void upload(File file) async {
    // simple loading toast when waiting server response result
    _loadingToast();

    // 取檔案路徑最後一個 '/' 餘後的內容作為檔案名字.
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      )
    });

    dio.post(vtcUrl, data: data).then((response) {
      // 結果轉換成 string 並返回
      String result = response.toString();
      log('SERVER RESPONSE: $response');

      BotToast.remove(key);

      _resultToast(result, 1);

      return result;
    }).catchError((error) {
      BotToast.remove(key);

      log('upload image go wrong: $error');
      _resultToast(error.toString(), 0);
    });
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

  void _resultToast(String text, int type) {
    BotToast.showNotification(
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: IconButton(
            icon: type == 1
                ? Icon(Ionicons.ios_rose, color: Colors.redAccent)
                : Icon(FontAwesome.times, color: Colors.redAccent),
            onPressed: cancel,
          )),
      title: (_) => Text(
        text,
        style: kBodyTextStyle,
      ),
      duration: Duration(seconds: 5),
    );
  }
}
