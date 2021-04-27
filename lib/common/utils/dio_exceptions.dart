import 'package:dio/dio.dart';

/// dio 請求返回提示處理封裝

class DioExceptions implements Exception {
  ///未知錯誤
  //Connection to API server failed
  static const String UNKNOWN = "UNKNOWN";

  ///解析錯誤
  static const String PARSE_ERROR = "PARSE_ERROR";

  ///網絡錯誤
  static const String NETWORK_ERROR = "NETWORK_ERROR";

  ///協議錯誤
  static const String HTTP_ERROR = "HTTP_ERROR";

  ///證書錯誤
  static const String SSL_ERROR = "SSL_ERROR";

  ///連接超時
  //Connection timeout with API server
  static const String CONNECT_TIMEOUT = "CONNECT_TIMEOUT";

  ///回應超時
  //Receive timeout in connection with API server
  static const String RECEIVE_TIMEOUT = "RECEIVE_TIMEOUT";

  ///發送超時
  //Send timeout in connection with API server
  static const String SEND_TIMEOUT = "SEND_TIMEOUT";

  ///網絡請求取消
  //Request to API server was cancelled
  static const String CANCEL = "CANCEL";

  DioExceptions.fromDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        _code = CANCEL;
        _message = "發送請求取消";
        break;
      case DioErrorType.connectTimeout:
        _code = CONNECT_TIMEOUT;
        _message = "連接伺服器超時";
        break;
      case DioErrorType.other:
        _code = UNKNOWN;
        _message = "呼叫 API 失敗, 請檢查網絡狀態";
        break;
      case DioErrorType.receiveTimeout:
        _code = RECEIVE_TIMEOUT;
        _message = "伺服器沒有及時作出回應";
        break;
      case DioErrorType.response:
        _code = HTTP_ERROR;
        _message = _handleError(error.response.statusCode, error.response.data);
        break;
      case DioErrorType.sendTimeout:
        _code = SEND_TIMEOUT;
        _message = "發送超時";
        break;
      default:
        _message = "程式我寫的，是我疏忽忘記寫必要的驗證了";
        break;
    }
  }

  String _message;
  String _code;

  String get messge => _message;
  String get code => _code;

  //HTTP status ranges in a nutshell:
  //1xx: hold on
  //2xx: here you go
  //3xx: go away
  //4xx: you fuck up
  //5xx: i fuck up

  String _handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 404:
        return error.toString();
      case 500:
        return error.toString();
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => 'DioError:\ncode: $_code\nmessage: $_message';
}
