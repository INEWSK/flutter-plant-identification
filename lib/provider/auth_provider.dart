import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/models/user.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider extends ChangeNotifier {
  Status _status = Status.Uninitialized;
  String _token;
  String _username = 'Guest';
  String _email = '';

  Dio dio = Dio(BaseOptions(
    connectTimeout: 10000, // 連接服務器超時時間，單位毫秒.
    receiveTimeout: 3000,
  ));

  /// getter
  Status get status => _status;
  String get token => _token;
  String get username => _username;
  String get email => _email;

  /// 默認請求地址
  final String baseUrl = 'https://florabackend.azurewebsites.net';
  // 本地測試請求地址
  final String localUrl = 'http://10.0.2.2:8000';

  initAuthProvider() async {
    String token = await getToken();
    if (token != null) {
      User user = await getUserData();
      _token = user.token;
      _email = user.email;
      _username = user.username;
      _status = Status.Authenticated;
      log('User Authenticated');
    } else {
      _status = Status.Unauthenticated;
      log('User Unauthenticated');
    }
    notifyListeners();
  }

  /// sign in method
  Future<Map> signIn(String email, String password) async {
    // set the status is authenticating
    _status = Status.Authenticating;
    notifyListeners();

    final url = "$localUrl/flora/signin/";

    final data = FormData.fromMap({
      'email': email,
      'password': password,
    });

    /// 用於返回結果給 UI 層
    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknow error.'
    };

    try {
      final response = await dio.post(url, data: data);

      /// Dio http 除了 200 狀態應該都直接 catch Exceptions
      result['success'] = true;
      result['message'] = 'Login Successfully';
      // 儲存用戶信息在本地
      await storeUserData(response.data);
      // 更新狀態
      _status = Status.Authenticated;
      // 通知 UI layer 更新 widget
      notifyListeners();

      return result;
    } on DioError catch (e) {
      /// 感覺這可以進行封裝統一管理 DIO ERROR, 留待日後繼續改進
      /// 這次項目的後台回傳的 status code 默認是 400
      /// UI 設置了 validator 規避了大部分無效 value input
      /// 後端返回是賬號密碼的錯誤
      if (e.response != null) {
        /// BE 統一返回 non_field_errors
        /// 不論密碼錯誤還是賬號不存在.
        /// 直接返回信息 UI layer 通知無效電郵或密碼
        result['message'] = 'Invalid Email or Password.';
        // Listener
        _status = Status.Unauthenticated;
        notifyListeners();

        return result;
      }

      /// 從封裝好的 DIO EXCEPTIONS 返回並查看的錯誤原因
      /// 這裏的錯誤往往是後端不能正確傳回狀態的,
      /// 譬如: 連接超時/沒有聯網
      final error = DioExceptions.fromDioError(e);
      // 輸出錯誤到主控台
      log(error.toString());
      // 返回錯誤信息給 UI layer
      result['message'] = error.messge;
      // LISTENER
      _status = Status.Unauthenticated;
      notifyListeners();

      return result;
    }
  }

  /// sign up method
  Future<Map> signUp(String email, String password1, String password2) async {
    final url = "$localUrl/flora/signup/";

    final data = FormData.fromMap({
      'email': email,
      'password1': password1,
      'password2': password2,
    });

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error.'
    };

    try {
      final response = await dio.post(url, data: data);
      // 後端有正確返回 token
      if (response.data['token'] != null) {
        // notify UI layout
        print(response.data);
        result['success'] = true;
        result['message'] = 'Sign up successful, please sign in again';

        return result;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        final response = e.response.data;

        /// 針對伺服器預設傳回的結果所包含内容進行指定動作
        /// 在 UI 層做了預先限制, 規避了部分錯誤結果
        if (response.containsKey('email')) {
          /// 如果與 email 相關: email 已經被注冊
          final String message = response['email'][0];

          result['message'] = message;

          return result;
        }

        /// 踩坑日記: containsKey 打錯 Editor 是不會提示你錯誤的
        if (response.containsKey('password1')) {
          /// 這裏在 UI 層面做了預先的限制, 不允許返回低於8位的密碼以及密碼不匹配
          /// 密碼太常見不予注冊
          final String message = response['password1'][0];

          result['message'] = message;

          return result;
        }
      }

      /// 無狀態回傳, 查看錯誤原因
      final error = DioExceptions.fromDioError(e);
      // 輸出錯誤到主控台
      log(error.toString());
      // UI message
      result['message'] = error.messge;

      return result;
    }

    // 狀況外, 後端沒有傳回 token
    return result;
  }

  /// store user data
  Future<void> storeUserData(response) async {
    _username = response['username'];
    _email = response['email'];
    _token = response['token'];

    var box = await Hive.openBox('authBox');

    box.put('username', _username);
    box.put('email', _email);
    box.put('token', _token);

    log('HiveBox: Auth data stored: ${box.toMap()}');
  }

  // get user data
  Future<User> getUserData() async {
    var box = await Hive.openBox('authBox');

    final token = box.get('token');
    final username = box.get('username');
    final email = box.get('email');

    User user = User(email, username, token);

    return user;
  }

  /// get token if logged
  Future<String> getToken() async {
    var box = await Hive.openBox('authBox');
    String token = box.get('token');

    return token;
  }

  /// sign out method
  void signOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    _token = null;
    _username = 'Guest';
    _email = '';

    // 檢查 token 是否過期(not apply yet)
    if (tokenExpired == true) {
      // Toast.show('Session expired. Please sign in again.');
    }
    notifyListeners();

    /// clear all auth data value
    var box = await Hive.openBox('authBox');
    box.clear().whenComplete(() => log('HiveBox: Auth data has been clear'));
  }
}
