import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_hotelapp/common/constants/rest_api.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/common/utils/dio_exceptions.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/models/user.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sp_util/sp_util.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider extends ChangeNotifier {
  Status _status = Status.Uninitialized;
  String _token;
  String _username = 'Guest';
  String _email = '';
  ImageProvider _image;
  bool _admin = false;

  Dio dio = Dio(BaseOptions(
    connectTimeout: 10000, // 連接服務器超時時間，單位毫秒.
    receiveTimeout: 3000,
  ));

  /// getter
  get status => _status;
  get token => _token;
  get username => _username;
  get email => _email;
  get admin => _admin;
  get image => _image;

  initAuthProvider() async {
    String token = await getToken();
    if (token != null) {
      User user = await getUserData();
      _token = user.token;
      _email = user.email;
      _username = user.username;
      _admin = user.admin;
      _status = Status.Authenticated;
      updateProfilePicture();
      log('User Authenticated');
    } else {
      _status = Status.Unauthenticated;
      log('User Unauthenticated');
    }
    notifyListeners();
  }

  updateProfilePicture() async {
    try {
      // 如果登入了查找 app 文件夾是否有現有的頭像
      if (_status == Status.Authenticated) {
        // 獲取用戶文件夾
        final userFolder = await getUserFolder();
        // 查找名爲 user_profile_picture 的文件是否存在
        final fileName = 'profile_picture';
        final imageFile = File('$userFolder/$fileName');
        // 如果有的話
        if (await imageFile.exists()) {
          SpUtil.putString('profilePicture', imageFile.path);
          print('獲取頭像文件夾\n' + 'PATH: ' + imageFile.path);
          if (Device.isMobile) {
            _image = FileImage(imageFile);
          }
        } else {
          _image = null;
          print('圖片不存在.');
        }
      } else {
        debugPrint('用戶未登入, 使用默認頭像');
      }
    } catch (e) {
      debugPrint('初始化頭像失敗\n' + 'REASON: ' + e.toString());
    }
  }

  /// sign in method
  Future<Map> signIn(String email, String password) async {
    // set the status is authenticating
    _status = Status.Authenticating;
    notifyListeners();

    final url = '${RestApi.localUrl}/flora/signin/';

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
      // 更新用户头像
      await updateProfilePicture();
      // 通知 UI layer 更新 widget
      notifyListeners();

      return result;
    } on DioError catch (e) {
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
    final url = '${RestApi.localUrl}/flora/signup/';

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
      // 伺服器有回應的情況下
      if (e.response != null) {
        final response = e.response.data;

        /// 針對伺服器預設傳回的結果所包含内容進行指定動作
        /// 在 UI 層做了預先限制, 規避了部分錯誤回應
        if (response.containsKey('email')) {
          ///  email 已經被注冊
          final String message = response['email'][0];

          result['message'] = message;

          return result;
        }

        /// 踩坑日記: containsKey 打錯 Editor 是不會提錯誤的
        if (response.containsKey('password1')) {
          /// 密碼太常見不予注冊
          final String message = response['password1'][0];

          result['message'] = message;

          return result;
        }
      }

      /// 伺服器無響應, 查看錯誤原因
      final error = DioExceptions.fromDioError(e);
      // 輸出錯誤到主控台
      log(error.toString());
      // UI message
      result['message'] = error.messge;

      return result;
    }

    // 狀況外
    return result;
  }

  /// store user data
  Future<void> storeUserData(response) async {
    response.toString();
    _username = response['username'];
    _email = response['email'];
    _token = response['token'];
    _admin = response['admin'];

    var box = await Hive.openBox('authBox');

    box.put('username', _username);
    box.put('email', _email);
    box.put('token', _token);
    box.put('admin', _admin);

    log('HiveBox: Auth data stored: ${box.toMap()}');
  }

  // get user data
  Future<User> getUserData() async {
    var box = await Hive.openBox('authBox');

    final token = box.get('token');
    final username = box.get('username');
    final email = box.get('email');
    final admin = box.get('admin');

    User user = User(email, username, token, admin);

    return user;
  }

  /// get token if logged
  Future<String> getToken() async {
    var box = await Hive.openBox('authBox');
    String token = box.get('token');

    return token;
  }

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
    // getting image
    final pickedFile =
        await _picker.getImage(source: ImageSource.gallery, maxWidth: 512);
    try {
      // check if an image has been picked
      if (pickedFile != null) {
        // create a file and file name for save
        final userFolder = await getUserFolder();
        final fileName = 'profile_picture';
        // save the file by copying it to the new location
        final imageFile =
            await File(pickedFile.path).copy('$userFolder/$fileName');
        print('已選擇的頭像\n' + 'PATH: ' + imageFile.path);
        // 由於 flutter 的圖片緩存機制, 複寫已存在的圖片不會即時改變
        // 直至重啓程序, 每次更新頭像需要清除緩存
        // 詳見 https://github.com/flutter/flutter/issues/24858
        imageCache.evict(FileImage(imageFile));
        // 持久化頭像
        SpUtil.putString('profilePicture', imageFile.path);
        // check if web platform
        if (Device.isWeb) {
          _image = NetworkImage(pickedFile.path);
        } else {
          _image = FileImage(imageFile);
        }
        notifyListeners();
      } else {
        // _imageProvider = null;
        // debugPrint('FILE PATH: 無文件被選擇');
      }
    } catch (e) {
      Toast.show('沒有權限使用相冊');
      debugPrint('頭像選擇發生錯誤: ' + e.toString());
    }
  }

  Future<String> getUserFolder() async {
    // get app doc folder
    final appDirectory = await getApplicationDocumentsDirectory();
    // create user folder for saving their picture
    // 以用戶的token命名
    final userFolder = Directory('${appDirectory.path}/$_token');
    // if folder already exists
    if (await userFolder.exists()) {
      debugPrint('用戶文件夾已存在\n' + 'PATH: ' + userFolder.path);
      return userFolder.path;
    } else {
      // if not exists, create new one
      final newUserFolder = await userFolder.create(recursive: true);
      debugPrint('創建新的用戶文件夾\n' + 'PATH: ' + newUserFolder.path);
      return newUserFolder.path;
    }
  }

  /// sign out method
  void signOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    _token = null;
    _username = 'Guest';
    _email = '';
    _image = null;
    _admin = false;

    // 檢查 token 是否過期(function not apply yet)
    if (tokenExpired == true) {
      // Toast.show('Session expired. Please sign in again.');
      // _status = Status.Unauthenticated;
    }
    notifyListeners();

    /// clear all auth data value
    var box = await Hive.openBox('authBox');
    box.clear().whenComplete(() => log('HiveBox: Auth data has been clear'));
    // clear user sp util data
    SpUtil.remove('profilePicture');
  }
}
