import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ApiProvider extends ChangeNotifier {
  final key = UniqueKey();

  Dio dio = Dio(BaseOptions(
    connectTimeout: 10000, // 10s
    receiveTimeout: 100000,
  ));

  final localUrl = 'http://10.0.2.2:80/flora/tree-ai/';
  // vtc network
  final vtcUrl = 'http://192.168.20.81:80/';

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

    // try call vtc network sever
    try {
      final vtcNetworkResponse = await dio.get(vtcUrl);
      // if server work correctly
      if (vtcNetworkResponse.statusCode == 200) {
        final apiUrl = "$vtcUrl/api/flora/tree-ai/";

        await dio.post(apiUrl, data: data).then((response) {
          // 結果轉換成 string 並返回
          String result = response.toString();
          log('SERVER RESPONSE: $response');

          BotToast.remove(key);

          _resultToast(result, true);

          //TODO: 根據伺服器傳回的資料對應相應的data, 用 dialog 顯示

          return result;
        });
      } else {
        log('api call: vtc network something gone wrong');
      }
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);

      print('api_provider: provider call error: ${error.messge}');
      print('vtc校內聯網url沒有回應, 嘗試call local url');

      Toast.show('vtc 校內聯網沒有回應, 呼叫本地 api');

      try {
        await dio.post(localUrl, data: data).then((response) {
          String result = response.toString(); // 直接string伺服器返回的結果
          log('SERVER RESPONSE: $response');

          BotToast.remove(key);

          _resultToast(result, true);

          return result;
        });
      } on DioError catch (e) {
        final error = DioExceptions.fromDioError(e);
        print(error.messge);
        _resultToast('Server was fucked up', false);
        BotToast.remove(key);
      }
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

  void _resultToast(String text, bool result) {
    BotToast.showNotification(
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: IconButton(
            icon: result == true
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
