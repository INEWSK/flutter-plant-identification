import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';

class ViewImageProvider extends ChangeNotifier {
  void upload(File file) async {
    // 取檔案路徑最後一個 '/' 餘後的內容作為檔案名字.
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      )
    });

    Dio dio = Dio();

    dio
        .post('http://10.0.2.2:8000/flora/tree-ai/', data: data)
        .then((response) {
      String msg = response.toString();
      log('SERVER RESPONSE: $response');
      Toast.show(msg);
    }).catchError((onError) => print(onError));
  }
}
