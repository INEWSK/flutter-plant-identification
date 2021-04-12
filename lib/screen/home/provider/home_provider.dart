import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/models/tree_info.dart';

class HomeProvider extends ChangeNotifier {
  List<TreeInfo> _list = [];

  List<TreeInfo> get list => _list;

  Future<bool> refresh() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  fetchData() async {
    Dio dio = Dio(BaseOptions(
      connectTimeout: 5000, // 5s
      receiveTimeout: 10000, // 10s
      // contentType 爲 json 則 response 自動轉化爲 json 對象
      // contentType: Headers.jsonContentType,
      responseType: ResponseType.plain,
    ));

    final path = '${RestApi.localUrl}/flora/info';

    try {
      final response = await dio.get(path);

      final data = treeInfoFromJson(response.data);

      return data;
    } catch (e) {
      print(e);
    }
  }
}
