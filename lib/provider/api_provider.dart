import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ApiProvider extends ChangeNotifier {
  final key = UniqueKey();

  Dio dio = Dio(BaseOptions(
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

    // try call vtc network sever
    try {
      final vtcNetworkResponse = await dio.get(RestApi.vtcUrl);
      // if server work correctly
      if (vtcNetworkResponse.statusCode == 200) {
        final url = RestApi.vtcUrl + '/flora/tree-ai/';
        // post request
        await dio.post(url, data: data).then((response) {
          // convert reponse body to string
          String result = response.toString();
          log('SERVER RESPONSE: $response');
          // remove loading toast
          BotToast.remove(key);
          _resultToast(result, true);
          //TODO: 根據伺服器傳回的資料對應相應的data, 用 dialog 顯示
          return result;
        });
      } else {
        // something wrong, please check vtc server
        log('vtc api call: something gone wrong');
      }
    } on DioError catch (e) {
      final error = DioExceptions.fromDioError(e);
      print('api_provider: provider call error: ${error.messge}');
      Toast.show('vtc 校內聯網沒有回應, 呼叫本地 api');

      final localUrl = RestApi.localUrl + '/flora/tree-ai/';
      // vtc network was fxxk, try to call local api
      try {
        await dio.post(localUrl, data: data).then((response) {
          String result = response.toString(); // 直接string伺服器返回的結果
          log('SERVER RESPONSE: $response');

          BotToast.remove(key);

          _resultToast(result, true);

          return result;
        });
      } on DioError catch (e) {
        // if local api mess up too, then
        final error = DioExceptions.fromDioError(e);

        print(error.messge);
        _resultToast(error.messge, false);

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
