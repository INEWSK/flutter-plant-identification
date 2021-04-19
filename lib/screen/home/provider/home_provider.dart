import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/models/tree_info.dart' as treeInfo;

enum Status { Init, Loaded, Refresh }

class HomeProvider extends ChangeNotifier {
  Status status = Status.Init;

  List<treeInfo.Result> _list = [];
  List<treeInfo.Result> get list => _list;

  Dio dio = Dio(BaseOptions(
    connectTimeout: 5000, // 5s
    receiveTimeout: 10000, // 10s
    // contentType json 則 response 自動轉化爲 json 對象
    responseType: ResponseType.plain,
  ));

  Future<List<treeInfo.Result>> fetchData() async {
    final path = '${RestApi.localUrl}/flora/info/';

    try {
      final response = await dio.get(path);

      final data = treeInfo.treeInfoFromJson(response.data);

      _list = data.results;

      return _list;
    } catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(message: error.messge, type: Type.Warning);
      Toast.error(title: '加載失敗', subtitle: '網絡發生了小問題, 請稍候刷新重試');
      return null;
    }
  }

  Future<bool> reloadData() async {
    final path = '${RestApi.localUrl}/flora/info';

    try {
      final response = await dio.get(path);

      final data = treeInfo.treeInfoFromJson(response.data);

      _list = data.results;
      notifyListeners();

      return true;
    } catch (e) {
      final error = DioExceptions.fromDioError(e);
      LoggerUtils.show(message: error.messge, type: Type.WTF);

      return false;
    }
  }
}
